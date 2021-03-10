---
title: Web UI 自动化测试实践
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
Vue的缺点：
全局的this
Vue 2 html、data声明、涉及方法代码片段分散，可复用性差

今日份吐血：
需要重复复制相同逻辑代码，功能代码分散
另一个页面需要使用，则需要复制相应的type action enum，
### 上下文丢失
Vue 的单文件组件，使用 <template> 、<script> 对代码进行分割，直接导致的问题就是上下文丢失。 举个例子，你封装了一些常用的函数，在 Vue 文件中 import 进来。你这个函数能在 template 中直接使用吗？ 不能。
需要在data或者method中中再次声明。
或者用namespace直接定义好action mutation

### 模板分割
好的代码组织能将常变与不变的部分进行分割解耦

Vue 的模板严重限制了这一点。 举个例子，前端有个下拉菜单，功能不断增加，而且对于不同的人要显示不同菜单（权限管理）。在 Vue 中，为了实现 html 代码（绑定在 template 中）的分割，你只能再搞一个组件。在 React 中，可以直接这样写：
```javascript
const menu = <div>abc<div>;
```
可单独做一个组件（低开销函数组件），也可当做变量，放在当前代码中。相对灵活很多。
SX 手写 render 渲染函数自带下面的优势

* 完整的 js 功能来构建视图页面，可以使用临时变量、js 自带的控制流、以及直接引用当前 js 作用域中的值
* 开发工具对 jsx 的支持比现有 vue 模板先进（linting、typescript、编译器自动补全）

参考资料：  
[为什么我们放弃了 Vue？Vue 和 React 深度对比](https://markdowner.net/article/79319258450055168)

