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


pub fn int_iter(params IntIterParams) IntIter {
	if params.step == 0 {
		panic('int_iter: step cannot be 0')
	}
	
	mut len := i64((params.stop - params.start)/params.step) + i64((params.stop - params.start)%params.step != 0)
	if len < 0 {
		len = 0
	}

	return IntIter{start: params.start,
					stop: params.stop,
					step: params.step,
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

pub fn float_iter(params FloatIterParams) FloatIter {
	if params.step == 0 {
		panic('float_iter: step cannot be 0')
	}
	mut len := int((params.stop - params.start)/params.step) + int(math.fmod((params.stop - params.start), params.step) != 0)
	if len < 0 {
		len = 0
	}
	return FloatIter{start: params.start,
					stop: params.stop,
					step: params.step,
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

pub fn lin_iter(params LinIterParams) LinIter {
	if params.len < 0 {
		panic('lin_iter: number of samples must be non negative')
	}
	mut step := f64(1)
	if params.endpoint {
		step = (params.stop - params.start)/(params.len-1)
	} else {
		step = (params.stop - params.start)/params.len
	}
	return LinIter{start: params.start,
					stop: params.stop,
					step: step,
					len: params.len,
					endpoint: params.endpoint}
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

pub fn log_iter(params LogIterParams) LogIter {
	if params.len < 0 {
		panic('log_iter: number of samples must be non negative')
	}
	return LogIter {lin_iter: lin_iter(start: params.start,
										stop: params.stop,
										len: params.len,
										endpoint: params.endpoint)
					base: params.base,
					len: params.len}
}

pub fn (mut o LogIter) next() ?f64 {
	return math.pow(o.base, o.lin_iter.next()?)
}