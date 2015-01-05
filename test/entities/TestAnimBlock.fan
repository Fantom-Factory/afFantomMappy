
class TestAnimBlock : Test {
	private AnimBlock? animBlock
	
	override Void setup() {
		animBlock = AnimBlock()		
		animBlock.frames = [55, 58, 69]
		animBlock.delay = 1
	}
	
	Void testUpdateAnim_AN_NONE() {
		animBlock.animFunc = AnimFunc().none
		
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
	}

	Void testUpdateAnim_AN_LOOPF() {
		animBlock.animFunc = AnimFunc().loopForward
		
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
	}

	Void testUpdateAnim_AN_LOOPR() {
		animBlock.animFunc = AnimFunc().loopReverse

		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
	}

	Void testUpdateAnim_AN_ONCE() {
		animBlock.animFunc = AnimFunc().animateOnce
		
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		
		// need AnimFunc fields to be static
//		verifyEq(animBlock.animFunc, AnimFunc().animateOnceFinished)
	}

	Void testUpdateAnim_AN_ONCES() {
		animBlock.animFunc = AnimFunc().animateOnceFinished
		
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
	}

	Void testUpdateAnim_AN_ONCEH() {
		animBlock.animFunc = AnimFunc().animateOnceAndHalt
		
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
	}

	Void testUpdateAnim_AN_PPFF() {
		animBlock.animFunc = AnimFunc().pingPongForwardOutwardLeg
		
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex, 		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex, 		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex, 		 1)
		
		// need AnimFunc fields to be static
//		verifyEq(animBlock.animFunc, AnimFunc().pingPongForwardReturnLeg)
	}

	Void testUpdateAnim_AN_PPFR() {
		animBlock.animFunc = AnimFunc().pingPongForwardReturnLeg
		animBlock.frameIndex = 2
		
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)

		// need AnimFunc fields to be static
//		verifyEq(animBlock.animFunc, AnimFunc().pingPongForwardOutwardLeg)
	}

	Void testUpdateAnim_AN_PPRF() {
		animBlock.animFunc = AnimFunc().pingPongReverseOutwardLeg
		animBlock.frameIndex = 2
		
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown, 	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		
		// need AnimFunc fields to be static
//		verifyEq(animBlock.animFunc, AnimFunc().pingPongReverseReturnLeg)
	}

	Void testUpdateAnim_AN_PPRR() {
		animBlock.animFunc = AnimFunc().pingPongReverseReturnLeg
		
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			55)
		verifyEq(animBlock.frameIndex,		 0)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 0)
		verifyEq(animBlock.frame, 			69)
		verifyEq(animBlock.frameIndex,		 2)
		animBlock.updateAnimation
		verifyEq(animBlock.delayCountdown,	 1)
		verifyEq(animBlock.frame, 			58)
		verifyEq(animBlock.frameIndex,		 1)
		
		// need AnimFunc fields to be static
//		verifyEq(animBlock.animFunc, AnimFunc().pingPongReverseOutwardLeg)
	}	
}
