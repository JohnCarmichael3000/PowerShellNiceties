#An oldie but this PowerShell still works like a charm, list the folders a specified domain user has access to:

#https://serverfault.com/questions/171320/list-users-folder-access-permissions
#You can use PowerShell without needing to download anything else. This will work with v2.0 and later:

$ReferenceAccountName = 'DOMAIN\Username'
[string[]]$SearchDirectories = @('X:\SomeDirectory', 'F:\AnotherDirectory')

foreach ($RootDir in $SearchDirectories) {
    $DirACL = Get-Acl -Path $RootDir
    foreach ($ACL in $DirACL.Access){
        if ($ACL.IdentityReference -like $ReferenceAccountName){
            Write-Output $RootDir
        }
    }
    foreach ($Directory in (Get-ChildItem -Path $RootDir -Recurse | `
                            Where-Object -FilterScript {$_.Attributes `
                            -contains 'Directory'})){
        $DirACL = Get-Acl -Path $Directory.FullName
        foreach ($ACL in $DirACL.Access){
            if ($ACL.IdentityReference -like $ReferenceAccountName){
                Write-Output $Directory.FullName
            }
        }
    }
}

#It is not as clean as what is available with PowerShell v3 and on, but it will work. This will output a list of the directories found in string format.

#Jon
#Would it also be possible to "exclude" inherited Permissions? (i.e. searching every Folder, where "DOMAIN\Username" has been added in an explicit way? – dognose Feb 27 '16 at 15:22
#Yes, you can: if ($ACL.IdentityReference -like $ReferenceAccountName -and !$ACL.IsInherited){ – dognose Feb 27 '16 at 15:31
