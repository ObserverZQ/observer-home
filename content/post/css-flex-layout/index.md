---
title: flex布局
description: 本文主要介绍Web PC自动化测试的步骤及实践
date: 2021-03-09T10:14:26+08:00
image: cover.jpg
categories:
    - 前端
    - 框架
tags:
    - Vue
    - React
---
flex: flex-grow flex-shrink flex-basis
flex-grow 属性定义项目的放大比例，默认值为0，不放大，x为放大x倍
flex-shrink 属性定义了项目的缩小比例，默认值为1，空间不足即缩小，0是不缩小
flex-basis 定义了在分配多余空间之前，项目占据的主轴空间（main size）。默认值为auto，项目默认的大小

| 语法 | 等于 | 描述 | 备注 |
| ------ | ------ | ------ | ------ |
| flex: initial | flex: 0 1 auto | 容器默认不放大，尺寸不足会缩小，尺寸自适应内容 | 初始值 |
| flex: 0 | flex: 0 1 0% | 默认放大，尺寸不足会缩小，大小支持0，即最小的内容尺寸 | 场景少 |
| flex: none | flex: 0 0 auto | 默认不放大，尺寸不足也不缩小，子项的尺寸就是父级的尺寸时使用 |  |
| flex: 1 | flex: 1 1 0% | 可以弹性变大，也可以弹性缩小，尺寸不足时优先最小化内容 |  |
| flex: auto | flex: 1 1 auto | 可以弹性变大，也可以弹性缩小，尺寸不足时优先最大化内容 | 基于内容动态匹配 |

参考资料：  
[Flex 布局教程：语法篇](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)

