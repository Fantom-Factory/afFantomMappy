
** A collection of standard animation functions as defined by Mappy.
** 
** FIXME: Should be a 'const' class with static fields. 
** See `http://fantom.org/sidewalk/topic/1973`
@Js
class AnimFunc {
	
	** 'AN_NONE'
	** 
	** Do Not Animate. By setting the animation type to 'none' the current frame will stay as it is.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 . . . ]
	|AnimBlock| none := |animBlock| { }
	
	** 'AN_LOOPF'
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 3 . . . ]
	|AnimBlock| loopForward := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex = 0
		}
    }
	
	** 'AN_LOOPR'
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 4 3 2 1 0 4 3 2 1 0 4 3 2 1 0 4 3 2 . . . ]
	|AnimBlock| loopReverse := |AnimBlock animBlock| {
		animBlock.decFrameIndex() |->| {
			animBlock.frameIndex = animBlock.frames.size - 1
		}		
    }
	
	** 'AN_ONCE'
	** 
	** After the animation sequence finishes the [currentFrameIndex]`AnimBlock.frameIndex`
	** resets to the first frame and the [animFunc]`AnimBlock.animFunc` changes to 
	** [animateOnceFinished]`animateOnceFinished`.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 0 1 2 3 4 0 0 0 0 0 0 0 0 0 0 0 0 0 . . . ]
	|AnimBlock| animateOnce := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex = 0
			animBlock.animFunc = AnimFunc().animateOnceFinished			
		}
    }
	
	** 'AN_ONCES'
	** 
	** The animation type is automatically set to this after the `animateOnce`
	** sequence has finished. 'animateOnceFinished' behaves the same as `none`.
	|AnimBlock| animateOnceFinished := |AnimBlock animBlock| { }
	
	** AN_ONCEH
	** 
	** After the animation sequence finishes the current frame sticks to the last frame. Unlike 
	** `animateOnce` the [animFunc]`AnimBlock.animFunc` does not change.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 0 1 2 3 4 4 4 4 4 4 4 4 4 4 4 4 4 4 . . . ]
	|AnimBlock| animateOnceAndHalt := |AnimBlock animBlock| { 
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex = animBlock.frames.size - 1
		}
	}
	
	** 'AN_PPFF'
	** 
	** When the animation sequence reaches the end of the forward 'ping' the 
	** [animFunc]`AnimBlock.animFunc` changes to `pingPongForwardReturnLeg` and the sequence begins 
	** its return journey.
	** 
	** It could be argued there is no difference between `pingPongForwardOutwardLeg` and 
	** `pingPongReverseReturnLeg` 
	** 	
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 0 1 2 3 4 3 2 1 0 1 2 3 4 3 2 1 0 1 . . . ]
	|AnimBlock| pingPongForwardOutwardLeg := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex -= 2
			animBlock.animFunc = AnimFunc().pingPongForwardReturnLeg
		}
	}
	
	** 'AN_PPFR'
	** 
	** When the animation sequence reaches the end of the forward 'pong' the
	** [animFunc]`AnimBlock.animFunc` changes to `pingPongForwardOutwardLeg` and the sequence 
	** starts all over again.
	** 
	** It could be argued there is no difference between `pingPongForwardReturnLeg` and 
	** `pingPongReverseOutwardLeg`.
	** 
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 4 3 2 1 0 1 2 3 4 3 2 1 0 1 2 3 4 3 . . . ]
	|AnimBlock| pingPongForwardReturnLeg := |AnimBlock animBlock| {
		animBlock.decFrameIndex() |->| {
			animBlock.frameIndex += 2
			animBlock.animFunc = AnimFunc().pingPongForwardOutwardLeg
		}		
	}
	
	** 'AN_PPRF'
	** 
	** When the animation sequence reaches the end of the reverse 'ping' the
	** [animFunc]`AnimBlock.animFunc` changes to `pingPongReverseReturnLeg` and the sequence 
	** begins its return journey.
	** 
	** It could be argued there is no difference between `pingPongReverseOutwardLeg` and
	** `pingPongForwardReturnLeg`.
	**  
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 4 3 2 1 0 1 2 3 4 3 2 1 0 1 2 3 4 3 . . . ]
	|AnimBlock| pingPongReverseOutwardLeg := |AnimBlock animBlock| {
		animBlock.decFrameIndex() |->| {
			animBlock.frameIndex += 2
			animBlock.animFunc = AnimFunc().pingPongReverseReturnLeg
		}				
	}
	
	** When the animation sequence reaches the end of the reverse 'pong' the
	** [animFunc]`AnimBlock.animFunc` changes to `pingPongReverseOutwardLeg` and the sequence 
	** starts all over again.
	** 
	** It could be argued there is no difference between `pingPongReverseReturnLeg` and
	** `pingPongForwardOutwardLeg`. 
	**  
	** Given 5 frames of animation, [currentFrameIndex]`AnimBlock.frameIndex` would update 
	** as follows:
	** 
	**   [ 0 1 2 3 4 3 2 1 0 1 2 3 4 3 2 1 0 1 . . . ]
	|AnimBlock| pingPongReverseReturnLeg := |AnimBlock animBlock| {
		animBlock.incFrameIndex() |->| {
			animBlock.frameIndex -= 2
			animBlock.animFunc = AnimFunc().pingPongReverseOutwardLeg
		}
	}
}
