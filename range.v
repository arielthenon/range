module range

import math

[params]
pub struct IntIterParams {
	start i64 
	stop  i64 [required]
	step  i64 = 1
}

struct IntIter {
	start i64
	stop i64
	step i64
mut: 
	i i64
pub:
	len i64
}


pub fn int_iter(i IntIterParams) IntIter {
	if i.step == 0 {
		panic('range: step cannot be 0')
	}
	
	mut len := i64((i.stop - i.start)/i.step) + i64((i.stop - i.start)%i.step != 0)
	if len < 0 {
		len = 0
	}

	return IntIter{start: i.start,
					stop: i.stop,
					step: i.step,
					i: 0
					len: len}
}


pub fn (mut r IntIter) next() ?i64{ 
	if r.i == r.len {
		return none
	}
	defer{ r.i ++}
	return r.start + r.i * r.step
}


[params]
pub struct FloatIterParams {
	start f64
	stop f64 [required]
	step f64 = 1.0
}

struct FloatIter {
	start f64
	stop f64
	step f64
mut: 
	i f64
pub:
	len i64
}

pub fn float_iter(i FloatIterParams) FloatIter {
	if i.step == 0 {
		panic('range: step cannot be 0')
	}
	mut len := int((i.stop - i.start)/i.step) + int(math.fmod((i.stop - i.start), i.step) != 0)
	if len < 0 {
		len = 0
	}
	return FloatIter{start: i.start,
					stop: i.stop,
					step: i.step,
					i: 0
					len: len}
}

pub fn (mut r FloatIter) next() ?f64{ 
	if r.i == r.len {
		return none
	}
	defer{ r.i ++}
	return r.start + r.i * r.step
}


[params]
pub struct LinIterParams {
	start f64 [required]
	stop f64 [required]
	len i64 = 50
	endpoint bool = true
}

struct LinIter {
	start f64
	stop f64
	endpoint bool
mut:
	i i64
pub:
	len i64 = 50
	step f64
}

pub fn lin_iter(i LinIterParams) LinIter {
	if i.len < 0 {
		panic('lin_iter: number of samples must be non negative')
	}
	mut step := f64(1)
	if i.endpoint {
		step = (i.stop - i.start)/(i.len-1)
	} else {
		step = (i.stop - i.start)/i.len
	}
	return LinIter{start: i.start,
					stop: i.stop,
					step: step,
					len: i.len,
					endpoint: i.endpoint}
}

pub fn (mut o LinIter) next() ?f64 {
	defer { o.i += 1 }
	if o.i < o.len -1 {
		return o.start + o.i*o.step
	} else if o.i == o.len -1 {
			if o.endpoint {
				return o.stop
			} else {
				return o.start + o.i*o.step
			}
	} else {
		return none
	}
}


[params]
pub struct LogIterParams {
	start f64 [required]
	stop f64 [required]
	len i64 = 50
	base f64 = 10.0
	endpoint bool = true
}

struct LogIter {
	base f64
pub:
	len i64
mut:
	lin_iter LinIter
}

pub fn log_iter(i LogIterParams) LogIter {
	if i.len < 0 {
		panic('log_iter: number of samples must be non negative')
	}
	return LogIter {lin_iter: lin_iter(start: i.start,
										stop: i.stop,
										len: i.len,
										endpoint: i.endpoint)
					base: i.base,
					len: i.len}
}

pub fn (mut o LogIter) next() ?f64 {
	return math.pow(o.base, o.lin_iter.next()?)
}