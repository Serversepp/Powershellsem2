

function MacheVerzeichnisse  ([string]$Pfad, [string]$VerzeichnisName,[int]$AnzahlV, [string]$DateiName, [string]$DateiTyp, [int]$AnzahlD, [int] $anzahlW,[int] $anzahlR, [Boolean] $sicherheit,[DateTime] $Anfangszahl, [DateTime] $Endzeit) {
# loop auf $AnzahlV
    for($i=0; $i -lt $AnzahlV; $i++) {
        # erstelle Verzeichnisse
        $izeros="{0:000}" -f $i
        $VPfad=$VerzeichnisName+$izeros
        New-Item -path $Pfad -name $VPfad -type directory -force -Value "ReadOnly"
        $dateiPfad=$Pfad+"\"+ $vPfad
        MacheDateien $DateiName $DateiTyp $AnzahlD $DateiPfad $anzahlR $anzahlW
        if ($sicherheit)
        {
            try
            {
                Add-MpPreference -ControlledFolderAccessProtectedFolders $dateiPfad -Force  -ErrorAction "Stop"
            }
            catch
            {
                Write-Host "Keine Berechtigung oder Deaktiviert!"
            }

        }
    }
}

function MacheDateien([string] $Dateiname, [string] $Dateityp, [int] $AnzahlDateien, [string] $Pfad, [int] $anzahlR, [int] $anzahlW) {
# loop auf AnzahlDateien
    for($i=0; $i -lt $AnzahlDateien; $i++) {
    # erstelle Dateien
        $izeros="{0:000}" -f $i
        $dateiname_all=$Dateiname+$izeros+$Dateityp
        New-Item -path $Pfad -name $Dateiname_all -type file -Force
        for ($j = 0; $j -lt $anzahlR; $j++) { # looping Anzahl Reihen
            Get-Randomstring $anzahlW  | Out-File -Append (($Pfad + '\' + $dateiname_all))
        }
        Set-CrationTime ((Get-RandomDate $Anfangszeit $Endzeit)) (($Pfad + '\' + $dateiname_all))


    }
}
function Get-Randomstring([int] $anzahlW){
    $inserstring=""
        for ($w=0;$w -lt $anzahlW; $w++){
        $inserstring+=$global:wort[$(Get-Random -Maximum $global:wort.Length)]

        }
        return $inserstring
}

function Get-RandomDate([DateTime] $minD, [DateTime] $maxD){
        return Get-Random -Minimum $minD.Ticks -Maximum $maxD.Ticks | Get-Date
}

function Set-CrationTime([DateTime] $Zufallszeit,[String] $Path){
    (Get-Item $Path -Force).CreationTime = $Zufallszeit
}

function findeWort([String] $Verzeichnisname, [String] $Wort) {
    [String]$Treffer = gci -r $Verzeichnisname  | Select-String -SimpleMatch $Wort | Select-Object -ExpandProperty Path  # -ExpandProperty steht hier weil ein Normales Select-Objekt Path nur in der shell selber als befehl aber nicht im script
    if ($null -ne $Treffer) # um zu verhindern das Verucht wird einen leeren String zu spliten
    {
        Write-Host "Suchwort" $Wort
        Write-Host "Treffer in :"
        foreach ($entry in $Treffer.Split(" "))
        {
            Write-Host $entry
        }
    }
    else
    {
        Write-Host "Keine Treffer"
    }
}

function prompt {
    "PS " + $(get-location) + " [$(Get-Date)] "  + "$( $env:UserName)" +" >"
}
function main() {
    $global:wort = @('Zero','One','Two','Three','Snerz')
    $pfad="c:\temp\umpf"
    $verzeichnisname="verz"
    $anzahlV=7
    $dateiname ="datei"
    $dateityp=".txt"
    $anzahlD=20
    $anzahlW=10
    $anzahlR=2
    $Anfangszeit=Get-Date('19.04.2001 12:00')
    $Endzeit=Get-Date('19.04.2007 13:00')
    $sicherheit=$TRUE
    $wort = "One"
    prompt
    macheVerzeichnisse $pfad $verzeichnisname $anzahlV $dateiname $dateityp $anzahlD $anzahlW $anzahlR $sicherheit $Anfangszeit $Endzeit
    findeWort $pfad $wort
}
Clear-Host
main