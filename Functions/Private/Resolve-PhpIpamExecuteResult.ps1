function Resolve-PhpIpamExecuteResult {
    [cmdletbinding()]
    param (
        $result
    )
    Write-Debug "Input Result=$($result|convertto-json)"

    if($result -and $result.success -and $result.data){
        return $result.data
    }else{
        #Write-Error $r
    }
}
