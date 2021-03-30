---
title: 从0开始实现React
description: Job Interview tips
date: 2021-03-30T12:20:26+08:00
image: react.jpeg
categories:
    - 框架原理
tags:
    - React
---
参考：https://pomb.us/build-your-own-react/
基于React 16.8实现，因而可以使用hook，不再书写使用过去的class相关的代码。

实现React的基本思路如下：
Step I: The createElement Function  第一步：创建节点
Step II: The render Function    第二步：渲染
Step III: Concurrent Mode     第三步：concurrent模式
Step IV: Fibers               第四步：Fiber“纤维”
Step V: Render and Commit Phases  第五步： 渲染和Commit阶段
Step VI: Reconciliation           第六步：调和
Step VII: Function Components   第七步：函数组件
Step VIII: Hooks                第八步：Hooks


# 第0步：回顾
下面是最简单的几行React代码：
```javascript
const element = <h1 title="foo">Hello</h1>
const container = document.getElementById("root")
ReactDOM.render(element, container) // 把element插入到页面的DOM节点container中
```
第一行代码替换成vanilla（香草？）JS代码，变化如下：
```javascript
// JSX 通过Babel编译成JS
// 一般转换过程都很简单：调用createElement把tag内的代码替换掉，传入tag名，属性和子节点作为参数
const element = <h1 title="foo">Hello</h1> 
// ========transformation=========
const element = React.createElement(
  "h1",
  { title: "foo" },
  "Hello"
)
// React.createElement 根据入参返回一个对象。中间还有一些校验。
// 所以我们可以直接将函数调用替换为函数最终的输出。
// 这就是React中一个element object，包含type和props两个字段（目前我们只关注这两个属性）
const element = {
    // type是一个字符串，表明我们想要创建的DOM节点的类型，和document.createElement方法中的tagName是一样的。type也可以是一个函数，这个留到第7步再作讲解。
    type: 'h1',
    // props是一个对象，它包含所有JSX属性的键值对。它还包含一个特殊的属性children。 
    props: {
        title: 'foo',
        // children在这里是一个字符串，但是它通常是一个数组，包含多个element。这也是elements也是树的原因。
        children: 'Hello' 
    }
};
```
然后还有第3行代码，这是React渲染/修改DOM的地方，现在由我们自己来实现这个更新。



首先我们根据React element的type去创建一个DOM节点node，在这个例子中是h1。
然后我们将element所有的属性prop添加到这个node上，这里暂时只有title。
```javascript
const node = document.createElement(element.type);
node['title'] = element.props.title;
```

然后我们为children创建DOM节点。这里只有一个文本作为child，所以我们创建为它创建一个text node。
```javascript
const text = document.createTextNode('');
// 用textNode而不是设置innerText会允许我们稍后用相同的方式来处理所有的elements。
// 同样要注意我们就像对h1设置title属性一样，对textNode设置nodeValue，就像这个字符串拥有自己的props: {nodeValue: "hello"}似的。
text['nodeValue'] = element.props.children;
```
最后，把text添加到h1 node中，把node添加到container中。
```javascript
node.appendChild(text);
container.appendChild(node);
```

现在，我们实现了之前依靠React JSX和React.render才实现的功能。
```javascript
const element = {
    type: 'h1',
    props: {
        title: 'foo',
        children: 'Hello' 
    }
};
const container = document.getElementById("root");
const node = document.createElement(element.type);
node['title'] = element.props.title;
const text = document.createTextNode('');
text['nodeValue'] = element.props.children;
node.appendChild(text);
container.appendChild(node);
```

# 第1步 createElement函数
现在，让我们用另一个app重新开始。
```javascript
const element = (
  <div id="foo">
    <a>bar</a>
    <b />
  </div>
)
const container = document.getElementById("root")
ReactDOM.render(element, container)
```
这次我们会用我们自己版本的React去替换原来的React。
我们从实现createElement函数开始。让我们将JSX转换为JS，从而看见createElement的调用。
```javascript
const element = React.createElement(
    'div',
    { id: 'foo' },
    [
        React.createElement('a', null, 'bar'),
        React.createElement('b')
    ]
)
```
正如我们上一步看到的那样，一个element是一个包含type和props两个属性的对象。所以我们的函数只需要执行创建对象的工作。
现在我们来实现createElement函数。
```javascript
//我们对props使用...扩展符号，对children使用剩余符号，这样children的值将一定是数组。
function createElement(type, props, ...children) {
    return {
        type,
        props: {
            ...props,
            children
        }
    }
}
const element = createElement('div');
// { type: 'div', props: { children: [] } }
const a = createElement('div', null, a);
// { type: 'div', props: { children: [a] } }
const c = createElement('div', null, a, b);
// { type: 'div', props: { children: [a, b] } }
```
children数组也可以包含基本类型，比如字符串或数字。所以我们会将非对象的类型包裹在一个element中，并创建一个特殊type，名叫TEXT_ELEMENT。
```javascript
function createElement(type, props, ...children) {
    return {
        type,
        props: {
            ...props,
            children: children.map(child => {
                typeof child === 'object' ? child : createTextElement(child)
            })
        }
    }
}
function createTextElement(text) {
    return {
        type: 'TEXT_ELEMENT',
        props: {
            nodeValue: text,
            children: []
        }
    }
}
```
注意，React源码并没有像这样包裹基本类型值或在没有children时创建空数组，但我们这样做可以简化代码。对于我们的库，我们更喜欢简单的代码，而非高性能的代码。

上文我们还在用React.createElement。现在，我们用Didact来替换React，表明为我们自己实现的库。目前，让它包含上面刚刚实现的createElement方法。
```javascript
const Didact = {
    createElement
}
const element = Didact.createElement(
    'div',
    { id: 'foo' },
    [
        Didact.createElement('a', null, 'bar'),
        Didact.createElement('b')
    ]
)
```
上面是编译后的JS代码。在这之前，我们还是得用JSX。那么我们怎么让babel知道要编译成Didact.createElement而不是React的createElement呢？
像这样注释，当babel编译JSX时它就会用我们定义的函数。
```javascript
/** @jsx Didact.createElement */
const element = (
  <div id="foo">
    <a>bar</a>
    <b />
  </div>
)
```