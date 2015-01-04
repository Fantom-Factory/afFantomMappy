
@Js
class AnimBlock {
	
	|AnimBlock|	animFunc	:= AnimFunc.instance.none
	
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
	
	Int? userData
	
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
	
	Void incFrameIndex(|->| clipFunc) {
		&frameIndex++
		if (&frameIndex >= frames.size)
			clipFunc()
	}

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


** A collection of standard animation functions as defined by Mappy.
** FIXME: http://fantom.org/sidewalk/topic/1973#
** Should be const class with static fields
@Js
class AnimFunc {
	
	** I lie!
	static AnimFunc instance() {
		AnimFunc()
	}
	
	** AN_NONE
	** 
	** Do Not Animate. By setting the animation type to 'none' the current frame will stay as it is.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . . . ]
	|AnimBlock| none := |animBlock| { }
	
	** AN_LOOPF
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 3 . . . ]
	|AnimBlock| loopForward := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex = 0
		}
    }
	
	** AN_LOOPR
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 4 3 2 1 0 4 3 2 1 0 4 3 2 1 0 4 3 2 . . . ]
	|AnimBlock| loopReverse := |AnimBlock animBlock| {
		animBlock.decFrameIndex() |->| {
			animBlock.frameIndex = animBlock.frames.size - 1
		}		
    }
	
	** AN_ONCE
	** 
	** After the animation sequence finishes the [currentFrameIndex]`AnimBlock.currentFrameIndex`
	** resets to the first frame and the [animType]`AnimBlock.animType` changes to 
	** [animateOnceFinished]`AnimType.animateOnceFinished`.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 0 1 2 3 4 0 0 0 0 0 0 0 0 0 0 0 0 0 . . . ]
	|AnimBlock| animateOnce := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex = 0
			animBlock.animFunc = AnimFunc.instance.animateOnceFinished			
		}
    }
	
	** AN_ONCES
	** 
	** The animation type is automatically set to this after the [animateOnce]`AnimType.animateOnce`
	** sequence has finished. 'animateOnceFinished' behaves the same as [none]`AnimType.none`.
	|AnimBlock| animateOnceFinished := |AnimBlock animBlock| { }
	
	** AN_ONCEH
	** 
	** After the animation sequence finishes the current frame sticks to the last frame. Unlike 
	** [animateOnce]`AnimType.animateOnce` the [animType]`AnimBlock.animType` does not change.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 0 1 2 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 . . . ]
	|AnimBlock| animateOnceAndHalt := |AnimBlock animBlock| { 
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex = animBlock.frames.size - 1
		}
	}
	
	** AN_PPFF
	** 
	** When the animation sequence reaches the end of the forward 'ping' the 
	** [animType]`AnimBlock.animType` changes to 
	** [pingPongForwardReturnLeg]`AnimType.pingPongForwardReturnLeg` and the sequence begins its
	** return journey.
	** 
	** It could be argued there is no difference between
	** [pingPongForwardOutwardLeg]`AnimType.pingPongForwardOutwardLeg` and 
	** [pingPongReverseReturnLeg]`AnimType.pingPongReverseReturnLeg` 
	** 	
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 0 1 2 3 4 3 2 1 0 1 2 3 4 3 2 1 0 1 . . . ]
	|AnimBlock| pingPongForwardOutwardLeg := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex -= 2
			animBlock.animFunc = AnimFunc.instance.pingPongForwardReturnLeg
		}
	}
	
	** AN_PPFR
	** 
	** When the animation sequence reaches the end of the forward 'pong' the
	** [animType]`AnimBlock.animType` changes to 
	** [pingPongForwardOutwardLeg]`AnimType.pingPongForwardOutwardLeg` and the sequence starts all
	** over again.
	** 
	** It could be argued there is no difference between
	** [pingPongForwardReturnLeg]`AnimType.pingPongForwardReturnLeg` and 
	** [pingPongReverseOutwardLeg]`AnimType.pingPongReverseOutwardLeg` 
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 4 3 2 1 0 1 2 3 4 3 2 1 0 1 2 3 4 3 . . . ]
	|AnimBlock| pingPongForwardReturnLeg := |AnimBlock animBlock| {
		animBlock.decFrameIndex() |->| {
			animBlock.frameIndex += 2
			animBlock.animFunc = AnimFunc.instance.pingPongForwardOutwardLeg
		}		
	}
	
	** AN_PPRF
	** 
	** When the animation sequence reaches the end of the reverse 'ping' the
	** [animType]`AnimBlock.animType` changes to 
	** [pingPongReverseReturnLeg]`AnimType.pingPongReverseReturnLeg` and the sequence begins its
	** return journey.
	** 
	** It could be argued there is no difference between
	** [pingPongReverseOutwardLeg]`AnimType.pingPongReverseOutwardLeg` and
	** [pingPongForwardReturnLeg]`AnimType.pingPongForwardReturnLeg` 
	**  
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**   [ 4 3 2 1 0 1 2 3 4 3 2 1 0 1 2 3 4 3 . . . ]
	|AnimBlock| pingPongReverseOutwardLeg := |AnimBlock animBlock| {
		animBlock.decFrameIndex() |->| {
			animBlock.frameIndex += 2
			animBlock.animFunc = AnimFunc.instance.pingPongReverseReturnLeg
		}				
	}
	
	** When the animation sequence reaches the end of the reverse 'pong' the
	** [animType]`AnimBlock.animType` changes to 
	** [pingPongReverseOutwardLeg]`AnimType.pingPongReverseOutwardLeg` and the sequence starts all
	** over again.
	** 
	** It could be argued there is no difference between
	** [pingPongReverseReturnLeg]`AnimType.pingPongReverseReturnLeg` and
	** [pingPongForwardOutwardLeg]`AnimType.pingPongForwardOutwardLeg` 
	**  
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.currentFrameIndex` would update 
	** as follows:
	**  [ 0 1 2 3 4 3 2 1 0 1 2 3 4 3 2 1 0 1 . . . ]
	|AnimBlock| pingPongReverseReturnLeg := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex -= 2
			animBlock.animFunc = AnimFunc.instance.pingPongReverseOutwardLeg
		}
	}
}
