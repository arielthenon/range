module range

import math

pub struct IntRangeInit {
	start i64 
	stop  i64 [required]
	step  i64 = 1
}

struct IntRange {
	start i64
	stop i64
	step i64
mut: 
	current i64
pub:
	len i64
}


pub fn irange(i IntRangeInit) IntRange {
	if i.step == 0 {
		panic('range: step cannot be 0')
	}
	
	mut len := i64((i.stop - i.start)/i.step) + i64((i.stop - i.start)%i.step != 0)
	if len < 0 {
		len = 0
	}

	return IntRange{start: i.start,
					stop: i.stop,
					step: i.step,
					current: i.start
					len: len}
}


pub fn (mut r IntRange) next() ?i64{ 
	if (r.stop -r.current) * r.step <= 0 {
		return none
	}
	defer{ r.current += r.step}
	return r.current
}



pub struct FloatRangeInit {
	start f64
	stop f64 [required]
	step f64 = 1.0
}

struct FloatRange {
	start f64
	stop f64
	step f64
mut: 
	i f64
pub:
	len i64
}

pub fn frange(i FloatRangeInit) FloatRange {
	if i.step == 0 {
		panic('range: step cannot be 0')
	}
	mut len := int((i.stop - i.start)/i.step) + int(math.fmod((i.stop - i.start), i.step) != 0)
	if len < 0 {
		len = 0
	}
	return FloatRange{start: i.start,
					stop: i.stop,
					step: i.step,
					i: 0
					len: len}
}

pub fn (mut r FloatRange) next() ?f64{ 
	if r.i == r.len {
		return none
	}
	defer{ r.i ++}
	return r.start + r.i * r.step
}


pub struct LinSpaceInit {
	start f64 [required]
	stop f64 [required]
	len i64 = 50
	endpoint bool = true
}

struct LinSpace {
	start f64
	stop f64
	endpoint bool
mut:
	i i64
pub:
	len i64 = 50
	step f64
}

pub fn linspace(i LinSpaceInit) LinSpace {
	if i.len < 0 {
		panic('linspace: number of samples must be non negative')
	}
	mut step := f64(1)
	if i.endpoint {
		step = (i.stop - i.start)/(i.len-1)
	} else {
		step = (i.stop - i.start)/i.len
	}
	return LinSpace{start: i.start,
					stop: i.stop,
					step: step,
					len: i.len,
					endpoint: i.endpoint}
}

pub fn (mut o LinSpace) next() ?f64 {
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


pub struct LogSpaceInit {
	start f64 [required]
	stop f64 [required]
	len i64 = 50
	base f64 = 10.0
	endpoint bool = true
}

struct LogSpace {
	base f64
pub:
	len i64
mut:
	linspace LinSpace
}

pub fn logspace(i LogSpaceInit) LogSpace {
	if i.len < 0 {
		panic('logspace: number of samples must be non negative')
	}
	return LogSpace {linspace: linspace(start: i.start,
										stop: i.stop,
										len: i.len,
										endpoint: i.endpoint)
					base: i.base,
					len: i.len}
}

pub fn (mut o LogSpace) next() ?f64 {
	return math.pow(o.base, o.linspace.next()?)
}