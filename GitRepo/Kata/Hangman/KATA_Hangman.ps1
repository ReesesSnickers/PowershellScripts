#THIS SCRIPT IS NOT COMPLETE. FOR NOTES REVOLVING AROUND THIS KATA SEE THE README FILE.

$gameState = $correct + " # " + " $incorrect"
$word = "testword"
$wordLines = $word -replace "\w", (" " + '_' + " ")
$correct = "Correct"
$incorrect = "Incorrect"
$array = $word.ToCharArray()

$head = "()"
$body = "||"
$ltArm = "-"
$rtArm = "-"
$ltLeg = "/"
$rtLeg = "\"

function gameImage
{
    Write-Output "                    ____
                   /    |
                   :    |
                  $head    |
                 $ltArm$body$rtArm   |
                  $ltLeg$rtLeg    |
                        |
                      __^__"
    Write-Output ""
    Write-Output $wordLines
    Write-Output ""
    Write-Output $gameState
    Write-Output ""
    Write-Output ""
    $guess = Read-Host "Your guess"
    
    foreach ($char in $array) {
        if ($guess -eq $char)
        {
            Write-Output "$guess is correct"
        }
        else
        {
            Write-Output "$guess is incorrect"
        }

    }
}

gameImage

