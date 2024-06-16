# Define the output directory and tool arguments
$output_dir = "tmp/chrome_10000_vids_0287095165"  # Update the directory as needed
$tool_args = "--mp4 --mp4-rand-size --safestart"
$randomization_args = "--randomize-slice-header --randomize-all-slices"
$config_file = "config/chrome.json"
$log_file = "$output_dir/randomized_10000_vids_0287095165.log"

# Log the output directory
Write-Output "Output directory: $output_dir"

# Ensure the output directory exists
if (-Not (Test-Path $output_dir)) {
    Write-Error "The output directory does not exist: $output_dir"
    exit 1
}

# Initialize the log file
Write-Output "Initialization of log file: $log_file"
Add-Content -Path $log_file -Value "Randomization Log - $(Get-Date)"

# Randomize the videos
Get-ChildItem "$output_dir\*.264" | ForEach-Object {
    $video_file = $_.FullName
    $randomized_file = [System.IO.Path]::ChangeExtension($video_file, ".randomized.264")
    $cmd = ".\h26forge.exe $tool_args randomize $randomization_args --config $config_file -i $video_file -o $randomized_file"

    # Log the command
    Write-Output "Executing: $cmd"
    Add-Content -Path $log_file -Value "------------------"
    Add-Content -Path $log_file -Value "Command: $cmd"
    
    # Execute the command and log the output
    try {
        Invoke-Expression $cmd | Out-File -FilePath $log_file -Append
    } catch {
        Write-Error "Error executing command: $_"
        Add-Content -Path $log_file -Value "Error: $_"
    }

    Add-Content -Path $log_file -Value "------------------"
}

# Final log message
Write-Output "Log saved to $log_file"
Add-Content -Path $log_file -Value "Log saved to $log_file - $(Get-Date)"
