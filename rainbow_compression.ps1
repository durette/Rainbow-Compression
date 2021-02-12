#!/bin/env pwsh

# Compress a single file using 7-Zip.
# Try many settings to make the smallest possible archive.

param (
  $input_file)

$compression_algorithms=@('LZMA', 'PPMd', 'BZip2', 'Deflate', 'BCJ', 'BCJ2', 'Copy')
$compression_levels=0..9
$executable_compressions=@('on', 'off')
$header_compressions=@('on', 'off')

$i=0

ForEach ($compression_algorithm In $compression_algorithms) {
  ForEach ($compression_level In $compression_levels) {
    ForEach ($executable_compression In $executable_compressions) {
      ForEach ($header_compression In $header_compressions) {
        $output_file="$($input_file)_$($i).7z"
        7z a "-mx=$($compression_level)" "-mf=$($executable_compression)" "-mhc=$($header_compression)" "-m0=$($compression_algorithm)" "$($output_file)" "$($input_file)"
        $i=$i+1
      }
    }
  }
}

$output_files = Get-ChildItem "$($input_file)_*.7z" | Sort-Object Length
$file_to_keep,$files_to_delete=$output_files
$file_to_keep | Rename-Item -NewName "$($input_file).7z"
$files_to_delete | Remove-Item
