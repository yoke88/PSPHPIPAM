# Powershell REST client module for PHPIPAM

this powershell module using PHPIPAM rest api to operate PHPIPAM tasks ,powershell version suggest 3.0 or above. i'm working to support powershell core 6.0 now， the main problem is Rijndael256 is not support in .net core now.


# 用于PHPIPAM 的Powershell REST API 客户端
该powershell 模组使用PHPIPAM REST API来操作PHPIPAM的一些任务。建议powershell 3.0 或者更高版本，目前我正在想办法支持powershell core 6.0 ,主要是Rijndael256 在.net core上实现的问题，原来用的System.Security.Cryptography.RijndaelManaged 在.net core 上，blocksize 只支持到128 位。而我们需要的是256 位。

### 该模块的主要结构
* 顶层目录的vagrantfile 是用vagrant 来搭建phpipam 环境时使用的，默认是virtualbox ,如果你是windows ,则会创建一个centos7.3 的虚拟机，然后在虚拟机内部使用docker 搭建PHPIPAM，如果你是linux ,默认会在你本机直接安装docker (如果没有安装的话)，然后直接用docker 在本机搭建PHPIPAM。

* psd1,psm1 后缀的文件是powershell 模组文件，psd1是模块的元数据，psm1 的代码主要是调用functions目录下的所有ps1 文件。
  * phpipamBaseFunctions.ps1 是整个模块的核心。这里实现了调用PHPIPAM API 的所有核心函数。
  * 其他以PHPIPAM Controller名称命名的ps1 文件，是针对这个Controller 实现的一些涉及到特定controller 的cmdlet.实际上都是调用invoke-phpipamexecute 这个函数 

### How to use vagrant Lab
 * install vagrant and virtualbox
 * git clone my repo and cd to psphpipam
 * vagrant up and wait the messages like blow:

 ```text
 ========================================================================
    config the phpipam env at      : http://127.0.0.1/
    the default mysql root pass is : my-secret-pw-Oo
 ========================================================================
 ```

### Examples

* 使用Token (也就是Cred Auth 方式)，这种对应于PHPIPAM 中的ssl 以及none 方式。发送用户名及密码+APPID，后会返回带有超时时间的token ,获取token 后，后续请求加上token就可以不再发送用户名及密码进行操作。

``` powershell
# Using Token Auth (Username + password + appid)
# username is admin ,and password is password ,and the apiid is script2
# if success , token will be cached in $GLOBAL:PHPIPAMTOKEN
 New-PhpIpamSession -useCredAuth -PhpIpamApiUrl http://127.0.0.1/api -AppID script2 -userName admin -password password

 # using invoke-phpipamexecute operate API
 # /api/my_app/sections/	Returns all sections
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @()

 # /api/my_app/sections/{id}/	Returns specific section ,id=1
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @(1)

 # /api/my_app/sections/{id}/subnets/	Returns all subnets in section
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @(1,'subnets')

 # /api/my_app/sections/{name}/	Returns specific section by name
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @('ipv6')

```

* 使用APPID，APPkey 的方式，这种方式也称为 Encryped request .就是用APPkey 加密**每次**请求的数据，这种方式是没有Token的，而且根据我的简短测试发现，这种方式的API支持不是太好。比如users Contoller,用这种方式就不能调用，因为users controller 必须要发送token ,而这种验证方式没有token返回。

``` powershell
# Using Encryped Request (APPID +APPKey)
# AppID is script and APPkey is  '5f40c5ba5730bdb93ca561efe5bae433' , APPID and APPKEY will be cached in $GLOBAL:PHPIPAMAPPID $GLOBAL:PHPIPAMAPPKEY
 New-PhpIpamSession -useAppkeyAuth -PhpIpamApiUrl http://127.0.0.1/api -AppID script -Appkey '5f40c5ba5730bdb93ca561efe5bae433'

 # using invoke-phpipamexecute operate API
 # /api/my_app/sections/	Returns all sections
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @()

 # /api/my_app/sections/{id}/	Returns specific section ,id=1
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @(1)

 # /api/my_app/sections/{id}/subnets/	Returns all subnets in section
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @(1,'subnets')

 # /api/my_app/sections/{name}/	Returns specific section by name
 Invoke-PhpIpamExecute -method get -controller sections -identifiers @('ipv6')

```
