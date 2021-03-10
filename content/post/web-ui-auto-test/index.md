---
title: Web UI 自动化测试实践
description: 本文主要介绍Web PC自动化测试的步骤及实践
date: 2021-03-08T10:54:26+08:00
image: cover.jpg
categories:
    - 前端
tags:
    - interview
    - Node.js
---
[Selenium](https://github.com/SeleniumHQ/selenium)：可以直接在浏览器中运行，目前使用版本v3，最高版本v4（不稳定）
安装、运行：http://www.testclass.net/selenium_python/install-selenium
可能遇到浏览器驱动问题，https://blog.csdn.net/tymatlab/article/details/78649727  http://www.testclass.net/selenium_python/selenium3-browser-driver
chrome驱动下载地址：https://sites.google.com/a/chromium.org/chromedriver/home

元素定位：http://www.testclass.net/selenium_python/find-element
对项目元素设置不同的classsname、css选择器，即可通过以下方法获取到该元素
```python
dr.find_element_by_class_name("s_ipt")
dr.find_element_by_css_selector("#kw")
dr.find_element_by_css_selector("[name=wd]")
dr.find_element_by_css_selector(".s_ipt")
dr.find_element_by_css_selector("html > body > form > span > input")
dr.find_element_by_css_selector("span.soutu-btn> input#kw")
dr.find_element_by_css_selector("form#form > span > input")
```
控制浏览器操作：
http://www.testclass.net/selenium_python/control-browser

其余操作：包括鼠标事件、键盘事件、窗口切换、文件上传、关闭浏览器等
http://www.testclass.net/selenium_python


cd ~ // 进入根目录
vim .bash_profile // 创建或者打开该文件

// .bash_profile以及.bashrc以及.zshrc均输入以下内容
export M2_HOME=/Users/mtdp/project/apache-maven-3.6.3  // /Users/mtdp/project/apache-maven-3.6.3 这个路径是自己存放maven的路径
export M2=$M2_HOME/bin // 不动
export PATH=$M2:$PATH  // 不动
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_192.jdk/Contents/Home   // 一般情况下只需要修改jdk版本号就好了，和自己安装的版本号一致，安装mvn和jdk后可以通过mvn -v查询到路径

// 保存后使用source命令
source .bash_profile/.bashrc/.zshrc

// java环境配置完成

// 修改maven的setting文件。进入maven安装目录打开conf下面的settings文件
1. 在自己的目录下新建java包存放文件夹，如maven_repostory，我的路径为/Users/mtdp/project/maven_repostory
2. 打开settings.xml文件，修改localRepository路径

<!--http://maven.apache.org/ref/3.5.0/maven-settings/settings.html-->
   <localRepository>/Users/mtdp/project/maven_repostory</localRepository>   // 改成自己的路径
    <servers>
        <!--only for temp migration start-->
        <server>
            <id>meituan-nexus-releases</id>
            <username>deployment</username>
            <password>deployment123</password>
        </server>
        <server>
        ...
// 安装python，由于mac本来自带python2，但是如果使用不当可能会引起mac系统崩溃，因此我们使用python3
brew install python3 // 安装python3，如果没有安装brew，使用/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"安装HOMEbrew
pip3 -V // 查看pip是否安装成功
pip3 install selenium // 使用piip安装selenium
brew install chromedriver
chromedriver --version // 查看版本
// 我试着直接下载安装包过，但是path总是找不到，运行代码问题频频出现，因此选择命令安装
// 另外安装后一开始不生效的话，建议重开一个终端运行即可

// 下载仓库代码
git clone ssh://git@git.sankuai.com/qa/case-uiauto.git

// java运行，进入仓库代码中存放pom.xml层级的目录
mvn test -DxmlFileName=testng.xml

// 默认用的是test环境，
// 如果用本地分支跑，可以把testng.xml中detailUrl修改成localhost:8421/case/product/detail/1295217958986731508?fromRoute=createdCase&amp;pageSize=10&amp;keyword=UI%E8%87%AA%E5%8A%A8%E5%8C%96&amp;offset=2

测试场景梳理：
UI自动化Demo运行需要搭建如下环境：jdk 1.8 + maven + Selenium WebDriver（Selenium 3）
参考资料：  
[Mac “'chromedriver' executable needs to be in PATH”](https://blog.csdn.net/tymatlab/article/details/78649727)

