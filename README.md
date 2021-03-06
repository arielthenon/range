# range

This module offers functionality similar to Python. 

There are 4 functions that create iterators with lazy evaluation:
- `int_iter`: similar to Python's `range()` for integer numbers
- `float_iter`: similar to Numpy's `arange` for floats
- `lin_iter`: similar to Numpy's `linspace`
- `log_iter`: similar to Numpy's `logspace`

The main defference with the Numpy functions is that the functions in this module return iterators rather than arrays, but can be used to create arrays.

All the iterators have a `len` attribute.

## Exemples

### `int_iter`

```v
for i in int_iter(stop:5) {
	println(i)
}
```
```console
0
1
2
3
4
```
-----------------
```v
for i in int_iter(start:3, stop:23, step:4) {
	println(i)
}
```
```console
3
7
11
15
19
```
------------
```v
for i in int_iter(start:5, stop:-10, step:-3) {
	println(i)
}
```
```console
5
2
-1
-4
-7
```
------
### `float_iter`

```v
for i in float_iter(start:1, stop:3, step:0.5) {
	println(i)
}
```
```console
1.
1.5
2.
2.5
```
-------
```v
for i in float_iter(stop:-1, step: -0.25) {
	println(i)
}
```
```console
0
-0.25
-0.5
-0.75
```
-------
### `lin_iter`
```v
for i in lin_iter(start: 0.5, stop: 1.25, len:5) {
	println(i)
}
```
```console
0.5
0.6875
0.875
1.0625
1.25
```
------
```v
for i in lin_iter(start: 0.5, stop: 1.25, len:5, endpoint: false) {
	println(i)
}
```
```console
0.5
0.65
0.8
0.95
1.1
```
------
### `log_iter`
```v
for i in log_iter(start: 0, stop: 3, len:5){
	println(i)
}
```
```console
1.
5.623413251903491
31.622776601683796
177.8279410038923
1000
```
------
```v
for i in log_iter(start: 0, stop: 3, len:5, base:2){
	println(i)
}
```
```console
1.
1.681792830507429
2.82842712474619
4.756828460010884
8.
```

### `.len`

```v
r := int_iter(stop:25, step:4)
println('len: $r.len')
```
```console
len: 7
```