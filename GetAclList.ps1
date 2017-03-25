$array = New-Object System.Collections.ArrayList
#�A�N�Z�X���ꗗ���擾����p�X
$targetDir = "C:\"
#���ʂ��o�͂���CSV�p�X
$exportCSVPath = "D:\acl.csv"

#�S�ẴT�u�f�B���N�g���̂�
#�t�@�C�����o�͂������ꍇ�ɂ́A�u Where { $_.PSIsContainer } |�v��
#�폜����
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
$array > $exportCSVPath