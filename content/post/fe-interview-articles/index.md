---
title: 常见面试题解析文章集锦
description: Job Interview tips
date: 2021-03-15T12:20:26+08:00
image: cover.jpg
categories:
    - 面试
tags:
    - 面试
---
1. 浏览器从输入URL到显示页面中间发生的事情
   
[一文摸透从输入URL到页面渲染的过程](https://www.cnblogs.com/AhuntSun-blog/p/12641050.html)

一言以概之：浏览器主进程 -> 网络进程 -> 渲染进程 -> GPU进程 -> 浏览器主进程


2. HTTP协议相关、网络攻击
   状态码、首部、请求方法、状态管理、身份认证、身份认证、长连接与短连接、代理网关与隧道、HTTP缓存、内容协商机制、断点续传和多线程下载、HTTPS、WebSocket、SPDY、HTTP 2.0、HTTP 3.0、Web安全
   [详解HTTP协议](https://www.cnblogs.com/AhuntSun-blog/p/12529920.html)

   URI包含URL、URN或同时具备locators和name特性的东西。URL给出了访问机制http ftp telnet等。URI唯一标识了身份。

请求首部：
   * Accept
   * Accet-Charset
   * Accept-Encoding
   * Accept-Language
   * If-Match  === ETag  200
   * If-Modified-Since < Last Modified  200
                     === Last Modified 304
   * If-None-Match !== ETag   200
   * If-Range  === ETag/date  206
                        !== ETag/date  200
    配合Range(Etag/date)使用
   * Referer: 告诉服务器从URI从哪个页面发起

响应首部：
   * Age 缓存在源服务器存在多久了
   * ETag 资源实体标识
   * Location 3xx 重定向用

通用首部：
   * Cache-Control
   * Connection
   * Date


1. 1. 浏览器从输入URL到显示页面中间发生的事情
2. 1. 浏览器从输入URL到显示页面中间发生的事情
3. 1. 浏览器从输入URL到显示页面中间发生的事情
4. 1. 浏览器从输入URL到显示页面中间发生的事情


vue 和 react 设计思路
发展历程
vue1
react15 diff平级
vue2
react16 fiber
vue3 & react17

vue
options API 缺点
要新增data，新增method，computed，watch，可维护性越来越差，反复横跳
mixin巨大的坑：命名冲突
this.xx 是一个黑盒 难测试 难推导

vue3 渐进式更新 ref api
composition API
缺点：难看 return。。 setup。。
优点：
1. 没有了options 可以做tree-shaking 代码build的时候就会删掉vue3里computed的代码
2. 方便组合，逻辑都是函数，组合优于继承。data和方法可以写在一起了
3. 组件可以任意拆分 到别的文件中，重名的话import的时候改名就可以了
4. 数据流清晰
对Vue.js进行了完全Typescript重构，让Vue.js源码易于阅读、开发和维护；

重写了虚拟Dom的实现，对编译模板进行优化、组件初始化更高效， 性能上有较大的提升；Vue.js2对象式组件存在一些问题：难以复用逻辑代码、难以拆分超大型组件、代码无法被压缩和优化、数据类型难以推倒等问题；而CompositionAPI 则是基于函数理念，去解决上述问题，使用函数可以将统一逻辑的组件代码收拢一起达到复用，也更有利于构建时的tree-shaking检测，这个使用起来有些类似于React的hook；

以上变化都秉持着VUE的“渐进式框架“ 理念， Vue.js3.0 持续开发兼容旧的版本，即使升级了Vue.js3.0 也可以按照之前的组件开发模式进行开发。
composition和hooks有啥区别？ API相像，底层实现不一样

react：class -》 hooks
hooks有顺序要求，不能放在if里
每次render都会执行

composition后续靠响应式通知


vue1 只有响应式，项目大了之后，响应式对象太多，导致卡顿
vue 响应式+vdom   
响应式：数据变了 通知你  通知机制
v-dom 数据变了 你不知道哪里变了，第一次diff才知道变化 怎么配合？


react没有响应式，纯v-dom，计算diff
v-dom树太大了，diff时间经常超过16.6ms，导致卡顿，怎么办？fiber

react单向数据流 更适合大型项目 一切皆组件

template不够动态，语法限制
v-if v-for 提前定义好的语法
好处：有限制，可遍历，优化空间比较大

jsx 动态化  任意创造div 纯js 使用js语法即可
element3

template 静态程度高 按需更新 节点的属性 子节点 判断出是否需要diff
自由度不高 编译器可优化点多

js 组合全县盐政 11
vue3 新概念 block

vue3 diff最精确 vue-next-template-explorer



二、虚拟dom
虚拟dom存在的意义：真正操作dom之前进行完整的diff计算，计算结果最小成本操作DOM
vue3 diff算法：最长递增子序列 + 双端预判

虚拟dom vue和react的区别
1. 响应式 主动通知
2. 虚拟dom被动计算

vue两个怎么配合？
根据组件划分，组件之间通过响应式通知，组件内部通过v-dom计算diff

svelte没有vdom，直接编译成js
vdom 用js的object来描述你的dom节点，跨端

vue1 dep一来中心 一个节点一个watcher
react15 平级对比diff On3 -》 On  diff上来就开始
vue2 引入了v-dom使用了snabdom的代码，双端预判，掐头去尾，减少diff，减少循环的次数  每个组件一个watcher

react fiber 时间切片
1. 任务可以切片  利用空闲时间计算
2. diff可以中断

树结构 变成 链表  节点之间一次走完
优先级高的任务来了，渲染，动画等，任务结束，继续diff

vue3
静态标记 静态的不用diff 编译时优化 理念源自prepack 把一些运行时的冗余计算在node层执行完 优化性能
在vue2静态标记的基础上，动态组件内部的静态标记
treeshaking 也是编译时优化

五、性能优化手段
减少计算
减少操作
compiler
vdom
工程化


the-super-tiny-compiler

react 解析jsx =》 createElement 没有太多的标记
vue3 template compile transform generate


babelloader webpack loader

try catch async await
可以写一个webpack的loader来做这个转换 加上错误通知机制 上报异常


* 说说 JavaScript 的数据类型 →
https://github.com/wengjq/Blog/issues/3
  * 通过 JSON.stringify 的方式实现深拷贝，会有什么问题？
1、如果obj里面有时间对象，则JSON.stringify后再JSON.parse的结果，时间将只是字符串的形式。而不是时间对象；
```javascript
 var test = {
        name: 'a',
        date: [new Date(1536627600000), new Date(1540047600000)],
      };

      let b;
      b = JSON.parse(JSON.stringify(test))
```
2、如果obj里有RegExp、Error对象，则序列化的结果将只得到空对象；
```javascript
      const test = {
        name: 'a',
        date: new RegExp('\\w+'),
      };
      // debugger
      const copyed = JSON.parse(JSON.stringify(test));
      test.name = 'test'
      console.error('ddd', test, copyed)
```
3、如果obj里有函数，undefined，则序列化的结果会把函数或 undefined丢失；
```javascript
   const test = {
        name: 'a',
        date: function hehe() {
          console.log('fff')
        },
      };
      // debugger
      const copyed = JSON.parse(JSON.stringify(test));
      test.name = 'test'
      console.error('ddd', test, copyed)
```
4、如果obj里有NaN、Infinity和-Infinity，则序列化的结果会变成null
5、JSON.stringify()只能序列化对象的可枚举的自有属性，例如 如果obj中的对象是有构造函数生成的， 则使用JSON.parse(JSON.stringify(obj))深拷贝后，会丢弃对象的constructor
```javascript
 function Person(name) {
        this.name = name;
        console.log(name)
      }

      const liai = new Person('liai');

      const test = {
        name: 'a',
        date: liai,
      };
      // debugger
      const copyed = JSON.parse(JSON.stringify(test));
      test.name = 'test'
      console.error('ddd', test, copyed)
```
6、如果对象中存在循环引用的情况也无法正确实现深拷贝；

* 通过递归的方式实现深拷贝，会有什么问题？
hasOwnProperty和for循环遍历属性
无法拷贝Date、RegExp等原生对象，其属性不可枚举
```javascript
     function deepClone(obj) {
      if(obj && typeof obj ==='object' ){
        var newObj= Array.isArray(obj) ? []:{};
        for (var key in obj) {
          if(obj.hasOwnProperty(key)){
            if(obj[key] && typeof obj[key]==='object'){
              newObj[key]=deepClone(obj[key] )
            }else {
              newObj[key]= obj[key]
            }
          }
        }
      }else {
        console.error('输入参数为空或不为对象');
        return '输入参数为空或不为对象'
      }
      return newObj
    }
```

兼容的做法：
包含Date RegExp Error undefined null
```javascript
function  deepClone(data) {
      const type = this.judgeType(data);
      let obj;
      if (type === 'array') {
        obj = [];
      } else if (type === 'object') {
        obj = {};
      } else {
    // 不再具有下一层次
        return data;
      }
      if (type === 'array') {
        // eslint-disable-next-line
        for (let i = 0, len = data.length; i < len; i++) {
          obj.push(this.deepClone(data[i]));
        }
      } else if (type === 'object') {
        // 对原型上的方法也拷贝了....
        // eslint-disable-next-line
        for (const key in data) {
          obj[key] = this.deepClone(data[key]);
        }
      }
      return obj;
    }


function  judgeType(obj) {
  // tostring会返回对应不同的标签的构造函数
      const toString = Object.prototype.toString;
      const map = {
        '[object Boolean]': 'boolean',
        '[object Number]': 'number',
        '[object String]': 'string',
        '[object Function]': 'function',
        '[object Array]': 'array',
        '[object Date]': 'date',
        '[object RegExp]': 'regExp',
        '[object Undefined]': 'undefined',
        '[object Null]': 'null',
        '[object Object]': 'object',
      };
      if (obj instanceof Element) {
        return 'element';
      }
      return map[toString.call(obj)];
    }
```
* 基本数据类型和引用数据类型有什么区别？→ 引用数据变量存的是地址
5种基本数据类型Undefined、Null、Boolean、Number 和 String，变量是直接按值存放的，存放在栈内存中的简单数据段，可以直接访问。存放在堆内存中的对象，变量保存的是一个指针，这个指针指向另一个位置。当需要访问引用类型（如对象，数组等）的值时，首先从栈中获得该对象的地址指针，然后再从堆内存中取得所需的数据。

* 引用数据类型如何进行拷？→ Object.assign
浅拷贝和深拷贝有什么区别？→
JavaScript存储对象都是存地址的，所以浅拷贝会导致 obj1 和obj2 指向同一块内存地址。改变了其中一方的内容，都是在原来的内存上做修改会导致拷贝对象和源对象都发生改变，而深拷贝是开辟一块新的内存地址，将原对象的各个属性逐个复制进去。对拷贝对象和源对象各自的操作互不影响。

* 目前 JavaScript 的 API 中，哪些是浅拷贝，哪些是深拷贝？→
浅拷贝：
```javascript
function shallowClone(copyObj) {
  var obj = {};
  for ( var i in copyObj) {
    obj[i] = copyObj[i];
  }
  return obj;
}
var x = {
  a: 1,
  b: { f: { g: 1 } },
  c: [ 1, 2, 3 ]
};
var y = shallowClone(x);
console.log(y.b.f === x.b.f);     // true
```
Object.assign
```javascript
var x = {
  a: 1,
  b: { f: { g: 1 } },
  c: [ 1, 2, 3 ]
};
var y = Object.assign({}, x);
console.log(y.b.f === x.b.f);     // true
```
深拷贝：
3.1、Array的slice和concat方法
JSON
如何实现一个深拷贝？→ 见上面代码
github版
```javascript
function copy (obj,deep) { 
    if ($.isFunction(obj)) {
    	return new Function("return " + obj.toString())();
    } else if (obj === null || typeof obj !== "object"){
        return obj; 
    }else {
        var name, target = $.isArray(obj) ? [] : {}, value; 
        for (name in obj) { 
            value = obj[name]; 
            if (value === obj) {
            	continue;
            }
            if (deep) {
                if ($.isArray(value) || $.isObject(value)) {
                    target[name] = copy(value,deep);
                } else if ($.isFunction(value)) {
                    target[name] = new Function("return " + value.toString())();
                } else {
            	    target[name] = value;
                } 
            } else {
            	target[name] = value;
            } 
        } 
        return target;
    }　        
}
```
* 数组去重的方式有哪些（手写）
```javascript
// 总结可分为两种
//1.两层循环法
//2.利用语法自身键不可重复性
let a = [2,3,4,1,2,2,4,111,123,321,123];
let b = [...new Set(a)]; // set的原理？

let c = a.filter((item, index) => {
   return a.indexOf(item) === index;
})
console.log('a', a);
console.log('b', b);
console.log('c', c);

// 其他方法
function unique (arr) {
  return Array.from(new Set(arr))
}

function unique(arr){            
        for(var i=0; i<arr.length; i++){
            for(var j=i+1; j<arr.length; j++){
                if(arr[i]==arr[j]){         //第一个等同于第二个，splice方法删除第二个
                    arr.splice(j,1);
                    j--;
                }
            }
        }
return arr;
}
```
* 找出数组中最大的数（手写）
```javascript
// 拿一个变量存max O（n）
// 从小到大排序后取最后一位

```
* 说一下事件循环的理解
答：JS是单线程，但是需要实现异步动作。浏览器或node环境为了实现异步操作的机制。浏览器执行主线程任务队列，然后micro tasks（timeout的回调，interval回调），然后macro tasks（promise的then回调），然后循环。node：idle，prepare。外部data、connection插入，然后是I/O callback，然后是check，然后是。。忘了。


 ┌───────────────────────┐
┌─>│        timers         │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
│  │     I/O callbacks     │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
│  │     idle, prepare     │
│  └──────────┬────────────┘      ┌───────────────┐
│  ┌──────────┴────────────┐      │   incoming:   │
│  │         poll          │<──connections───     │
│  └──────────┬────────────┘      │   data, etc.  │
│  ┌──────────┴────────────┐      └───────────────┘
│  │        check          │
│  └──────────┬────────────┘
│  ┌──────────┴────────────┐
└──┤    close callbacks    │
   └───────────────────────┘
timers: 这个阶段执行定时器队列中的回调如 setTimeout() 和 setInterval()。
I/O callbacks: 这个阶段执行几乎所有的回调。但是不包括close事件，定时器和setImmediate()的回调。
idle, prepare: 这个阶段仅在内部使用，可以不必理会。
poll: 等待新的I/O事件，node在一些特殊情况下会阻塞在这里。
check: setImmediate()的回调会在这个阶段执行。
close callbacks: 例如socket.on('close', ...)这种close事件的回调。

* 快排是如何实现的，讲一下思路和复杂度
答：整体思路是把数组划分为三部分，左边比基准值小，右边的都比基准值大，然后对切分之后的数组再次进行划分

* 如何实现一个观察者模式（手写）

* 如何实现一个单例模式（手写）
```javascript
class Singleton {
  constructor (name) {
    this.name = name;
    if (!Singleton.instance) {
      Singleton.instance = this;
    }
    return Singleton.instance;
  }
}

// 将函数作为一个参数传递
var Singleton = function(fn) {
    var instance
    return function() {
        // 通过apply的方式收集参数并执行传入的参数将结果返回
        return instance || (instance = fn.apply(this, arguments))
    }
}
// 模拟一个遮罩层
var createDiv = function () {
    var div = document.createElement('div')
    div.style.width = '100vw'
    div.style.height = '100vh'
    div.style.backgroundColor = 'red'
    document.body.appendChild(div)
    return div
}

// 创建出这个元素
var createSingleLayer = Singleton(createDiv)

document.getElementById('btn').onclick = function () {
    // 只有在调用的时候才展示
    var divLayer = createSingleLayer()
}
// 当然，在实际应用中还是有很多适用场景的，比如登录框，还有我们可能会使用到的 Vux 之类的状态管理工具，它们实际上都是契合单例模式的

```
* 如何解析一个 URL，获取 query 和 hash 的参数（手写）
```javascript
function getHash(url) {
  // const hash = window.location.hash;
  let hashIndex = url.indexOf('#');
  let hash = url.substring(hashIndex + 1);
  console.log(hash);
}
let h = 'https://juejin.cn/post/6844904088337907720#comment';
getHash(h);
function getQuery(url) {
  //  window.location.search ?xxx=ddd
  let queryIndex = url.indexOf('?');
  let queryStr = url.substring(queryIndex + 1);
  let queryObj = {};
  queryStr.split('&')
          .forEach(str => {
              queryObj[str.split('=')[0]] = str.split('=')[1];
          }
  );
  console.log(queryObj);
  return queryObj;
}
let url = 'http://localhost:3001/dashboard/list?dashboard=38353&isCore=false';
getQuery(url);

function getQueryWithReg(name) {
  const reg = new RegExp('(^|&)'+name+'=([^&]*)(&|$)', 'i');
  let str = window.location.search.substring(1);
  let matches = str.match(reg);
  if (matches !== null) {
    return matches;
  }
}
getQueryWithReg(url);
```
* TypeScript 和 JavaScript 最大的区别在哪

* Vue和React区别
  1. 监听数据变化原理不同 vue用Object.defineProperty getter setter（Vue 3用proxy）muttable react 比较引用 需要专门优化PureComponent/shouldComponentUpdate react fiber
  2. 数据绑定：vue 双向数据绑定 react单向 必须setState
  3. 组合不同功能：React用HoC，vue用mixin（方法重名问题）
  4. 组件通信：vue 事件 emit  React 回调方法
  5. 模板渲染方式：vue html， React JSX 表面上语法不同。深层次上，
React是在组件JS代码中，通过原生JS实现模板中的常见语法，比如插值，条件，循环等，都是通过JS语法实现的
Vue是在和组件JS代码分离的单独的模板中，通过指令来实现的，比如条件语句就需要 v-if 来实现。
对这一点，我个人比较喜欢React的做法，因为他更加纯粹更加原生，而Vue的做法显得有些独特，会把HTML弄得很乱。举个例子，说明React的好处：
react中render函数是支持闭包特性的，所以我们import的组件在render中可以直接调用。但是在Vue中，由于模板中使用的数据都必须挂在 this 上进行一次中转，所以我们import 一个组件完了之后，还需要在 components 中再声明下，这样显然是很奇怪但又不得不这样的做法。
