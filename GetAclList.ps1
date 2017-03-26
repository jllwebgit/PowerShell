Param(
    [Parameter(mandatory=$true,HelpMessage="�A�N�Z�X���ꗗ���擾����p�X")]
    [string]$targetDir,
    [Parameter(mandatory=$true,HelpMessage="���ʃt�@�C�����o�͂���CSV�p�X")]
    [string]$exportCSVPath,
    [ValidateSet($TRUE,$FALSE)]
    [string]$DirectoryOnly
)

$array = New-Object System.Collections.ArrayList

#�f�B���N�g���̂�
function SearchListDirectoryOnly
{
    Get-ChildItem -Recurse -Path $targetDir | Where { $_.PSIsContainer } |
    forEach {
        $objPath = $_.FullName
        $coLACL  = Get-Acl -Path $objPath
        forEach ( $objACL in $colACL ) {
            forEach ( $accessRight in $objACL.Access ) {
                $array.add($objPath + "," + `
                           $accessRight.IdentityReference + "," + `
                           $accessRight.FileSystemRights + "," + `
                           $accessRight.AccessControlType + "," + `
                           $accessRight.IsInherited + "," + `
                           $accessRight.InheritanceFlags + "," + `
                           $objACL.AreAccessRulesProtected `
                           )
            }
        }
    }
    return $array
}

#�t�@�C���ƃf�B���N�g��
function SearchList
{
    Get-ChildItem -Recurse -Path $targetDir |
    forEach {
        $objPath = $_.FullName
        $coLACL  = Get-Acl -Path $objPath
        forEach ( $objACL in $colACL ) {
            forEach ( $accessRight in $objACL.Access ) {
                $array.add($objPath + "," + `
                           $accessRight.IdentityReference + "," + `
                           $accessRight.FileSystemRights + "," + `
                           $accessRight.AccessControlType + "," + `
                           $accessRight.IsInherited + "," + `
                           $accessRight.InheritanceFlags + "," + `
                           $objACL.AreAccessRulesProtected `
                           )
            }
        }
    }
    return $array
}

if ($DirectoryOnly -eq $true){
    SearchListDirectoryOnly
}else{
    SearchList
}

#���X�g���\�[�g
$array.Sort()
#1�s�ڂɍ��ڂ�Insert
$array.insert(0,"Path,`
                IdentityReference,`
                FileSystemRights,`
                AccessControlType,`
                IsInherited,`
                InheritanceFlags,`
                AreAccessRulesProtected"`
                )

#�o�͌��ʂ��G�N�X�|�[�g
$array > $exportCSVPath