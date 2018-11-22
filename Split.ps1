param (
		[Parameter(Mandatory=$true)] [string] $InputFile
	,	[Parameter(Mandatory=$true)] [string] $OutputPath
)

function Write-Outputfile ($FilePath, $Content){
	Write-Host "New File $FilePath :" -ForegroundColor Cyan
	$Content > $FilePath
}

function Create-OutputFolder ($OutputPath) {
	if (!(Test-Path -Path $OutputPath)) {
		New-Item $OutputPath -ItemType Directory
	}
}

Create-OutputFolder -OutputPath $OutputPath

$i = 0
foreach ($line in get-content $inputfile) {
	if ($line.contains('/****** Object:  StoredProcedure ')) {
		
		if ($i -gt 0) {
			Write-Outputfile -FilePath $(Join-Path $OutputPath -ChildPath $OutputFileName) -Content $OutputFileContent
		}
		$i++
		
		$OutputFileName = "$($line.Substring(50,$line.IndexOf(']    Script Date: ')-50)).sql"
		
		$OutputFileContent += $Null
		$OutputFileContent = ($line + "`r`n")
	} else {
		$OutputFileContent += ($line + "`r`n")
	}
}

Write-Outputfile -FilePath $(Join-Path $OutputPath -ChildPath $OutputFileName) -Content $OutputFileContent