function get-idear{
    [cmdletbinding()]
    param(

    )
    return $Script:idear;
}


function set-idear{
    [cmdletbinding()]
    param(
        $idear
    )
    $script:idear=$idear
}

Export-ModuleMember -Function @("get-idear","set-idear")
