# Powershell REST Client Module For PHPIPAM

[![Build status](https://ci.appveyor.com/api/projects/status/5730189ukhlife0l?svg=true)](https://ci.appveyor.com/project/yoke88/psphpipam)



this powershell module using PHPIPAM rest api to operate PHPIPAM tasks ,powershell version suggest 3.0 or above.

this module works on powershell core 6.0 and above now ,and the test environment is mainly on linux and powershell core

## Alerts

> No support and test with PHPIPAM 'encryped' Application security mode. 

## 用于PHPIPAM 的Powershell REST API 客户端
该powershell 模组使用PHPIPAM REST API来操作PHPIPAM的一些任务。建议powershell 3.0 或者更高版本，目前已经支持powershell core 6.0，最新的测试环境已经移到linux 环境，并且主要使用powershell core 6.x 进行测试．


## 该模块的主要结构和文件说明

- Docs 目录放置说明还有截图，而且模块的每个内置的函数也尽量包含了example 和说明，你可以使用get-help command 来获取帮助

- Tests 目录放置pester 测试文件，该测试文件针对vagrant 搭建的phpipam 开发环境进行测试．

- PSPHPIPAM 目录放置该模块的主要的函数＼包括基础模块函数还有其他扩展的函数．如果你要扩充模块，请添加命令到Functions\Public ，参考其他的函数命令，比如Functions\Public|TestIdears

- Nginx 是PhpIpam 测试开发环境使用的nginx 配置文件及证书，我会使用vagrant 来创建一个PHPipam 的环境，其使用docker 搭建了一个可用的Phpipam环境

-　`buildenv.*` 可以用来创建PHPIPAM 开发测试环境，需要安装vagrant，virtualbox [参考](Docs/1.create_dev_env_with_vagrant.md) 也可以直接使用docker-compose 




### Examples

Read the docs:
- [Use vagrant to create a dev env](Docs/1.create_dev_env_with_vagrant.md)
- [Configure API account](Docs/2.configure_API.md)
- read example test file under Tests\*.ps1

### How to Debug
The functions in this module mainly used powershell advanced function feature (the function which contains `[cmdletbinding()]`, so when you encounter errors ,you can add the `-debug` switch to see what's goging on there,you can add your `write-debug ` expression to the function to see more information if you want.


Debug like this
``` powershell
New-PhpIpamSession -useCredAuth -PhpIpamApiUrl http://127.0.0.1/api -AppID script2 -userName admin -password password -debug
```
