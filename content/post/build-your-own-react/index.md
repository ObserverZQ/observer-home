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

# 第2步 render函数
创建好了element，现在我们要实现自己的render函数，将一个object转换为DOM节点并添加到container中：
```javascript
ReactDOM.render(element, container)
```
现在，我们只关注添加节点到DOM中。我们稍后会再处理update和delete操作。
```javascript
const Didact = {
    createElement,
    render
}
function render(element, container) {
    // TODO create dom nodes
}
// ...jsx
// const container = document.getElementById('root')
Didact.render(element, container);
```

我们从根据type创建一个DOM node，然后将该node添加到container中开始：
```javascript
function render(element, container) {
    // 在这里也要对text节点特殊处理，如果type为之前设定的TEXT_ELEMENT，则需要调用createTextNode方法
    const dom = element.type === 'TEXT_ELEMENT' ? document.createTextNode('') : document.createElement(element.type);
    
    // 还记得每个element的属性吗？除了children，其余的属性都要绑定到对应的DOM node上
    const isProperty = key => key !== 'children';
    Object.keys(element.props).filter(isProperty).forEach(name => {
        dom[name] = element.props[name];
    });

    // 然后对element的每个子节点做递归操作，生成DOM node并添加到该element对应的DOM node中，形成真正的DOM树
    element.children.forEach(child => {
        render(child, dom);
    });
    container.appendChild(dom);
}
```
完成。现在我们有了一个可以将JSX转译为DOM的库了。https://codesandbox.io/s/didact-2-k6rbj?file=/src/index.js


# 第3步 concurrent模式
在添加更多代码前，我们需要做个重构。上面的forEach render递归调用存在一个问题，就是当element树太大时，它可能会阻断主线程太久。
而且，如果浏览器需要执行高优先级的工作，例如提交用户输入，或者保障动画流畅播放，那么浏览器就要等到它完成渲染。

所以我们要将渲染工作拆分成小的单元，每执行完一个，浏览器发现还有别的是事情要做的话就会中断渲染。
```javascript
// 我们用requestIdleCallback来建立一个循环。你可以把它看作setTimeout，但是不是由我们去告诉它什么时候运行，而是由浏览器在主线程空闲是去执行callback。

// React不再使用requestIdleCallback。现在它使用scheduler package。但是在这个用例中它们的概念是类似的。
let nextUnitOfWork = null;
// 入参deadline可以用来检查在浏览器需要重新take control之前我们还有多少时间去执行渲染
function workLoop(deadline) {
    let shouldYield = false;
    while (nextUnitOfWork && !shouldYield) {
        nextUnitOfWork = performUnitOfWork(nextUnitOfWork);
        shouldYield = deadline.timeRemaing() < 1
    }
    requestIdleCallback(workLoop)
}
requestIdleCallback(workLoop)
function performUnitOfWork(nextUnitOfWork) {
    // TODO
}
```
As of截至2019年11月, Concurrent Mode还没有发布稳定版本。循环的稳定版本更像是下面这样：
```javascript
while (nextUnitOfWork) {    
  nextUnitOfWork = performUnitOfWork(   
    nextUnitOfWork  
  ) 
}
```
要开始使用这个循环，我们需要设置任务的第一个单元，然后编写performUnitOfWork方法，这个方法不仅执行当前的任务，还会返回下一个单元的任务。


# 第4步 fiber树
我们需要一种形如纤维树的数据结构来组织单元任务。每个React element，都会有一个对应的fiber，它们是一一对应的关系。

举个例子：
假设我们要渲染一个像这样的element树结构到DOM中：
```javascript
Didact.render(
  <div>
    <h1>
      <p />
      <a />
    </h1>
    <h2 />
  </div>,
  container
)
```
![fiber1.png](fiber1.png)
在render函数中我们会创建根fiber，然后将其设为nextUnitOfWork。其余的工作会在performUnitOfWork中进行，在该函数中我们会对每个fiber做以下三件事：

1. add the element to the DOM 将element添加到DOM
2. create the fibers for the element’s children 为这个fiber的children创建它们自己的fiber
3. select the next unit of work 选择下一个单元任务
   
这样类似纤维的数据结构的一个好处就是由于每个fiber都和自己的第一个子节点、相邻节点和父节点有一个连接，可以很容易确认下一个单元任务，即下一个要进行渲染的element。

* 当我们完成了对一个fiber的任务的执行，如果这个fiber有子节点，那么这个子节点就会成为下一个单元任务。对于本例，当我们完成div这个fiber的工作，下一个单元任务将会是h1这个fiber。

* 如果当前的fiber没有子节点，我们会让它的相邻节点成为下个单元任务。例如，p这个fiber没有子节点，所以我们会在完成渲染它之后移动到a这个fiber。
![fiber3.png](fiber3.png)

* 而如果这个fiber没有子节点也没有相邻节点，我们会去找它的“叔叔”：父节点的相邻节点，例如本例中的h2。
![fiber4.png](fiber4.png)
另外，如果父节点没有相邻节点，我们继续向上沿着父节点寻找，直到找到了有相邻节点的父节点，或者是到达根节点。如果我们到达了根节点，则说明我们已经完成了对这次render的所有任务。

现在让我们用代码进行实现吧！

首先将原先render函数里的创建DOM的代码抽离出来：
```javascript
function render(element, container) {
    // 创建DOM
    const dom = element.type === 'TEXT_ELEMENT' ? document.createTextNode('') : document.createElement(element.type);
    const isProperty = key => key !== 'children';
    Object.keys(element.props).filter(isProperty).forEach(name => {
        dom[name] = element.props[name];
    });

    // 对子节点递归调用
    element.children.forEach(child => {
        render(child, dom);
    });
    // 添加到容器中
    container.appendChild(dom);
}
```
将创建DOM的部分抽离出来形成一个新的方法createDOM，入参为fiber，即element。稍后我们会用到这个方法。
```javascript
function createDom(fiber) {
    const dom = fiber.type === 'TEXT_ELEMENT' ? document.createTextNode('') : document.createElement(fiber.type);
    const isProperty = key => key !== 'children';
    Object.keys(fiber.props)
        .filter(isProperty)
        .forEach(name => {
            dom[name] = fiber.props[name];
        });
    return dom;
}
```
然后，在render方法中，我们把fiber树的根节点作为nextUnitOfWork:
```javascript
function render (element, container) {
    // 最初最初的节点为container，一个已有的DOM节点，放在nextUnitOfWork，即fiber的dom属性中
    // nextUnitOfWork对象还有type属性，最初节点没有自身属性，只有children，包含一个我们创建好的element
    let nextUnitOfWork = {
        dom: container,
        props: {
            children: [element]
        }
    }
}

let nextUnitOfWork = null
```
然后，当浏览器ready后，它会调用我们上面所写的workLoop方法，我们就会开始从root进行渲染工作。
现在我们来实现performUnitOfWork方法。
```javascript
function performUnitOfWork(fiber) {
    // 1. 首先，我们创建一个新的DOM node，并将其添加到DOM中
    // 我们用fiber.dom属性去追踪DOM节点信息
    if (!fiber.dom) {
        fiber.dom = createDom(fiber);
    }
    if (fiber.parent) {
        fiber.parent.dom.appendChild(fiber.dom);
    }

    // 2. 然后我们为每一个子节点创建一个新的fiber
    const elements = fiber.props.children;
    let prevSibling = null;
    for (let i = 0; index < elements.length; i++) {
        const element = elements[i];
        const newFiber = {
            type: element.type,
            props: element.props,
            dom: null,
            parent: fiber
        }
        // 建立fiber连接，根据索引是否为0设置为当前fiber的child或是上一个子节点的相邻节点
        if (i === 0) {
            fiber.child = newFiber;
        } else {
            prevSibling.sibling = newFiber;
        }
        prevSibling = newFiber;
    }

    // 3. 最后我们搜索并确立下一个单元任务。我们先试试子节点child，没有child的话就相邻节点=》父节点的相邻节点这样循环搜索。
    if (fiber.child) {
        return fiber.child;
    }
    let nextFiber = fiber;
    while (nextFiber) {
        if (nextFiber.sibling) {
            return nextFiber.sibling;
        }
        nextFiber = nextFiber.parent;
    }
}
```
以上就是performUnitOfWork方法的实现。


# 第5步：Render和Commit阶段
现在我们还面临一个问题。每次我们对一个element进行操作时，都会将一个新的node姐弟那添加到DOM中，但是记住，浏览器可以在我们完成渲染整个树结构之前中断渲染工作去执行更高优先级的任务，在那种情况下，用户会看见一个不完整的UI。我们不希望那种情况发生。所以我们需要将修改DOM的代码片段抽离出来。
```javascript
function performUnitOfWork(fiber) {
    // ...
    // 修改DOM，需要提出去
    if (fiber.parent) {
        fiber.parent.dom.appendChild(fiber.dom);
    }
    // ...
}
```
反之，我们需要持续跟踪fiber树的根。我们称它为work in progress root或wipRoot。在render方法中重新命名：
```javascript
function render (element, container) {
    wipRoot = {
        dom: container,
        props: {
            children: [element]
        }
    }
    nextUnitOfWork = wipRoot;
}
let nextUnitOfWork = null;
let wipRoot = null;
```
然后，当我们完成了所有的渲染工作（不存在下一个单元任务时）我们将整个fiber树提交到DOM中（每个fiber都已经带有了它对应要渲染到document上的附带属性的DOM节点）。
```javascript
function commitRoot() {
  // TODO add nodes to dom
}
function render(element, container) {
  wipRoot = {
    dom: container,
    props: {
      children: [element],
    },
  }
  nextUnitOfWork = wipRoot
}
​
let nextUnitOfWork = null
let wipRoot = null
​
function workLoop(deadline) {
  let shouldYield = false
  while (nextUnitOfWork && !shouldYield) {
    nextUnitOfWork = performUnitOfWork(
      nextUnitOfWork
    )
    shouldYield = deadline.timeRemaining() < 1
  }
​  // 没有下一个单元任务，说明fiber树构建完成，整体提交到DOM中
  if (!nextUnitOfWork && wipRoot) {
    commitRoot()
  }
  requestIdleCallback(workLoop)
}
​
requestIdleCallback(workLoop)
```
我们在commitRoot方法中实现提交功能。在commitWork里递归添加所有node到DOM树中。
```javascript
function commitRoot() {
    // 这里child就是实际要添加到已有DOM容器节点的根element
    commitWork(wipRoot.child);
    wipRoot = null;
}
function commitWork(fiber) {
    if (!fiber) {
        return;
    }
    const fiberParentDom = fiber.parent.dom;
    fiberParentDom.appendChild(fiber.dom);
    commitWork(fiber.child);
    commitWork(fiber.sibling);
}
```