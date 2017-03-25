Param(
    [Parameter(mandatory=$true,HelpMessage="アクセス権一覧を取得するパス")]
    [string]$targetDir,
    [Parameter(mandatory=$true,HelpMessage="結果ファイルを出力するCSVパス")]
    [string]$exportCSVPath
)

$array = New-Object System.Collections.ArrayList

#全てのサブディレクトリのみ
#ファイルも出力したい場合には、「 Where { $_.PSIsContainer } |」を
#削除する
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

#リストをソート
$array.Sort()
#1行目に項目をInsert
$array.insert(0,"Path,`
                IdentityReference,`
                FileSystemRights,`
                AccessControlType,`
                IsInherited,`
                InheritanceFlags,`
                AreAccessRulesProtected"`
                )
$array > $exportCSVPath