Set-StrictMode -Version latest
$ErrorActionPreference = "Stop"

function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ("Error executing command {0}" -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

if (!(Test-Path "..\eventcollector"))
{
    Exec { git clone https://github.com/cdctentacles/eventcollector.git ..\eventcollector }
}

if (!(Test-Path "..\azure-event-bus-collector"))
{
    Exec { git clone https://github.com/cdctentacles/azure-event-bus-collector.git ..\azure-event-bus-collector }
}

if (!(Test-Path "..\producer-plugin"))
{
    Exec { git clone https://github.com/cdctentacles/producer-plugin.git ..\producer-plugin }
}

if (!(Test-Path "..\sample-cdc-sf-app"))
{
    Exec { git clone https://github.com/cdctentacles/sample-cdc-sf-app.git ..\sample-cdc-sf-app }
}

Write-Host "Building EventCollector .. !!!"

pushd ..\eventcollector
Exec { .\build_tests.ps1 }
popd

Write-Host "Building Azure Event Bus Collector .. !!!"

pushd ..\azure-event-bus-collector
Exec { .\build_tests.ps1 }
popd

Write-Host "Building SF Plugin .. !!!"

pushd ..\producer-plugin
Exec { .\build_tests.ps1 }
popd

Write-Host "Building Sample CDC SF App .. !!!"

pushd ..\sample-cdc-sf-app
Exec { .\build_tests.ps1 }
popd

Write-Host "Success build and test code .. !!!"

Write-Host "Running git status on all the repos.."

Write-Host "In eventcollector directory.."
pushd ..\eventcollector
git status
popd
Write-Host "In azure event bus collector directory.."
pushd ..\azure-event-bus-collector
git status
popd
Write-Host "In producer-plugin directory.."
pushd ..\producer-plugin
git status
popd
Write-Host "In sample-cdc-sf-app directory.."
pushd ..\sample-cdc-sf-app
git status
popd
Write-Host "In current directory directory.."
git status
