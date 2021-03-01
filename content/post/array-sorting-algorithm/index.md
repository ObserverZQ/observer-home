---
title: JavaScript实现常见排序算法
description: 主要介绍冒泡排序、选择排序、插入排序、合并排序、快速排序
date: 2021-02-26T19:11:26+08:00
image: array_sorting_algorithm.png
categories:
    - 算法
    - 排序
    - 数组
tags:
    - interview
    - algorithm
    - sorting
---

### 冒泡排序
基本思路：从左至右遍历数组，取一个指针指向第一个元素，与下一个元素比较，若该元素更大则前后交换位置，然后指针取下一位，与后一位进行比较，继续这样的循环，这样一轮下来会使得最大值放在数组的末尾，类似吐泡泡一样。之后重新开始循环上述过程，将第二大的元素放在倒数第二位。
```javascript
function bubbleSort(array) {
    let isSorted = true;
    let len = array.length;
    for (let i = 0; i < len; i ++) {
        for (let j = 0; j < len - i - 1; j++) {
            if (array[j] > array[j +1 ]) {
                [array[j], array[j + 1]] = [array[j + 1], array[j]];
                isSorted = false;
            }
        }
        if (isSorted) {
            break;
        }
    }
    return array;
}

```
### 选择排序
基本思路：从左至右遍历数组，比较一圈后得到最小值的索引，与索引0的元素交换位置；接着从第2位开始循环上述操作，将第二小的元素放在索引为1的位置，以此类推。每次遍历的时间为O(n)，这样的时间复杂度为O(n2)。
```javascript
function selectionSort(array) {
    for (let i = 0, len = array.length; i < len - 1; i++) {
        let min = i;
        for (let j = i + 1; j < len; j++) {
            if (array[j] < array[min]) {
                min = j;
            }
        }
        [array[i], array[min]] = [array[min], array[i]]
    }
    return array;
}
```

### 插入排序

### 快速排序quicksort

#### 法一
基本思路：选择一个基准值（随意选择），遍历数组（除基准值以外），将比基准值小的push到一个数组，放到基准值左侧，将比基准值大的push到另一个数组，放到基准值右侧，并对新的两个数组继续递归调用该函数，即为该函数的返回结果。基线条件为入参数组的长度为1，结束递归，直接返回该数组。递归过程逐个栈完成调用返回结果。
```javascript
function quickSort(array) {
    if (array.length < 2) {
        return array;
    }
    let pivot = array[0];
    let low = [];
    let high = [];
    for (let i = 1; i < array.length; i++) {
        if (array[i] <= pivot) {
            low.push(array[i]);
        } else {
            high.push(array[i]);
        }
    }
    return quickSort(low).concat(pivot, quickSort(high));
}
```
每层实际还是遍历了O(n)个元素，而调用栈共有O(log n)层（相当于二分，所以是2的对数），所以平均情况的时间复杂度为O(n) * O(log n) = O(nlogn)。
最糟情况下，例如一个已经排好序的数组，基准值从第一个元素取，则调用栈为n层，此时时间复杂度为O(n2)。但是一般都不会遇到最糟情况。

#### 法二
实现分析：

将当前数组分区
分区时先选择一个基准值，再创建两个指针，左边一个指向数组第一个项，右边一个指向数组最后一个项。移动左指针直至找到一个比基准值大的元素，再移动右指针直至找到一个比基准值小的元素，然后交换它们，重复这个过程，直到左指针的位置超过了右指针。如此分区、交换使得比基准值小的元素都在基准值之前，比基准值大的元素都在基准值之后，这就是分区（partition）操作。
对于上一次分区后的两个区域重复进行分区、交换操作，直至分区到最小。
```javascript
function quickSort(unsorted) {
  function partition(array, left, right) {
    const pivot = array[ Math.floor((left + right) / 2) ];

    while (left <= right) {
      while (array[left] < pivot) {
        left++;
      }

      while (array[right] > pivot) {
        right--;
      }

      if (left <= right) {
        [array[left], array[right]] = [array[right], array[left]];
        left++;
        right--;
      }
    }

    return left;
  }

  function quick(array, left, right) {
    if (array.length <= 1) {
      return array;
    }

    const index = partition(array, left, right);

    if (left < index - 1) {
      quick(array, left, index - 1);
    }

    if (right > index) {
      quick(array, index, right);
    }

    return array;
  }

  return quick(unsorted, 0, unsorted.length - 1);
}
```

### 合并排序mergesort
基本思路：取位于数组中间的值，将左侧右侧各生成一个新数组（split），然后调用merge函数，各用一个索引进行逐个遍历比较，将较小的推送至结果数组中，直至其中一个数组遍历结束，对有剩余元素的那个数组在尾部加至结果数组。对新数组递归拆分操作，并调用该merge函数，直至左右数组的长度为0。

将数组从中间切分为两个数组
切分到最小之后，开始归并操作，即合并两个已排序的数组
递归合并的过程，由于是从小到大合并，所以待合并的两个数组总是已排序的，一直做同样的归并操作就可以
```javascript
function mergeSort(array) {
    function merge(arrL, arrR) {
        let indexL = indexR = 0;
        const lenL = arrL.length;
        const lenR = arrR.length;
        const result = [];
        while (indexL < lenL && indexR < lenR) {
            if (arrL[indexL] <= arrR[indexR]) {
                result.push(arrL[indexL++]);
            } else {
                result.push(arrR[indexR++]);
            }
        }
        while (indexL < lenL) {
            result.push(arrL[indexL++])
        }
        while (indexR < lenR) {
            result.push(arrR[indexR++])
        }
        return result;
    }
    function split(array) {
        const len = array.length / 2
        let mid = Math.floor(len);
        const arrL = array.slice(0, mid);
        const arrR = array.slice(mid, len);
        return merge(split(arrL), split(arrR));
    }
    return split(array);
}
```
归并排序的时间复杂度是 O(nlog(n))，是实际工程中可选的排序方案。

### 对比归并排序与快速排序
1. 都用了分治的思想。相比选择排序和冒泡排序，归并排序与快速排序使用了切分而不是直接遍历，这有效减少了交换次数。
2. 归并排序是先切分、后排序，过程可以描述为：切分、切分、切分……排序、排序、排序……
3. 快速排序是分区、排序交替进行，过程可以描述为：分区、排序、分区、排序……
4. 上两条所说的“排序”，在归并排序与快速排序中并非同样的操作，归并排序中的操作是将两个数组合并为一（归并操作），而快速排序中的操作是交换。
5. 归并排序，由小及大，小的排好序的数组递归合并为大的排好序的数组，逐渐递归覆盖到整个原始数组；快速排序，由大及小，先将大的整个数组根据基准值进行大小分区，再逐渐切小，对小的分区进行大小分区。


参考资料：
[归并排序与快速排序的简明实现及对比](https://www.ituring.com.cn/article/497588)
