# Log filtering script
# Author: Alexandros Bouzalas
# Date: 02/03/2021

# Replace the paths with correct ones

$start = Get-Date
"`n$start`n"

# Name der neuen Datei
$file_name = Read-Host -Prompt "Name of the new file"

# Make a new file with the name we specified above
Out-File $file_name -Force -Encoding ascii 


# Define a limit so that the log files that have already been filtered don't get filtered again
$limit = (Get-Date).AddDays(-3)

# Unzip function
Expand-Archive -Path 'Path to the .zip file' -Force

# Variable for the current file we are filtering
$i = 0 
# Variable for the amount of files meeting the requirement in the if loop below
$n = 0

# Getting the amount of files in a certain folder ending on .log
$folders = Get-ChildItem -Path 'Path to the folder containing the .log files' -Name -Recurse -Include *.log

# Get the amount of files that meet the age requirement
foreach($Item in $folders){
    if ((Get-Item ('Path to the folder containing the .log files' + $Item)).LastWriteTime -gt $limit){
        $n++
    }
}

# Nested for loops that loop through every .log file the meets the age requirement and filter only the errors using a regex match
foreach($item in $folders) {
    $files = 'Path to the folder containg the .log files' + $item
    foreach($file in $files){
        $content = Get-Content $file
        if ((Get-Item $file).LastWriteTime -gt $limit) {
            Write-Progress -Activity "Filtering..." -Status "File $i of $n" -PercentComplete (($i / $n) * 100)
            $i++
            foreach($line in $content) {
                if ($line -match '([ ][4-5][0-5][0-9][ ])') {
                # Pipe the matches into the file we specified above
                Add-Content -Path $file_name -Value $line
                }
            }
        }   
    }
}

# Get and Display the runtime of the script 
$end = Get-Date
$time = [int]($end - $start).TotalSeconds
Write-Output ("Runtime: " + $time + " seconds" -join ' ')


