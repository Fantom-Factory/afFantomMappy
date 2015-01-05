
** Represents a 'AnimBlock' as used by Mappy. 
@Js
class AnimBlock {
	
	** The function that defines the animation frame sequence.
	** Defaults to 'AnimFunc.none'
	|AnimBlock|	animFunc	:= AnimFunc().none
	
	** The 'delay'is the number of times `AnimBlock.updateAnimation` needs to be called before the 
	** 'currentFrameIndex' changes. In effect this controls the speed of the animation.
	Int delay {
		set { 
			if (it < 0) throw ArgErr("delay '$it' should be positive")
			&delay = it 
		}
	}
	
	** Returns the number of times `AnimBlock.updateAnimation` has to be called before the current 
	** frame is changed to the next in sequence. 
	** 
	** If 'delayCountdown == 0' the current frame will change on the next call to 
	** `AnimBlock.updateAnimation` and 'delayCountdown' will reset to 'delay'.
	Int delayCountdown {
		set {
			if (it < 0) throw ArgErr("delayCountdown '$it' should be positive")
			&delayCountdown = it 
		}
	}
	
	** User data.
	Int? userData
	
	** The current frame index.
	Int frameIndex {
		set { 
			if (it < 0) 			throw ArgErr("frameIndex '$it' should be positive") 
			if (it > frames.size) 	throw ArgErr("frameIndex '$it' can not be more than no. of frames '$frames.size'") 
			&frameIndex = it 
		}
	}

	** Returns the current frame (image index). If this AnimBlock has no frames then 0 is returned
	Int frame {
		get {
			((frameIndex < 0) || (frameIndex >= frames.size)) ? 0: frames[frameIndex]
		}
		private set
	}

	** An array of frames (image indexes) that represent the animation sequence
	Int[] frames := [,]

	
	
	// ---- Public Methods ----------------------------------------------------
	
	** Increments the frame index. 
	** Should the index exceed the maximum ( 'frames.size' ) then the given 'clipFunc' is called.
	Void incFrameIndex(|->| clipFunc) {
		&frameIndex++
		if (&frameIndex >= frames.size)
			clipFunc()
	}

	** Decrements the frame index. 
	** Should the index drop below zero then the given 'clipFunc' is called.
	Void decFrameIndex(|->| clipFunc) {
		&frameIndex--
		if (&frameIndex < 0)
			clipFunc()
	}
	
	** Counts down the delay and updates the current frame to the next in the animation sequence.
	Void updateAnimation() {
		&delayCountdown--
		if (&delayCountdown < 0) {
			&delayCountdown = delay
			
			// let the animFunc do all the leg work
			animFunc(this)
		}
	}
}
