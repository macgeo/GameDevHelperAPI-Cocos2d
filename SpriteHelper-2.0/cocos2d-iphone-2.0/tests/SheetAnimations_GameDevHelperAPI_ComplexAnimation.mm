
#import "SheetAnimations_GameDevHelperAPI_ComplexAnimation.h"


@implementation SheetAnimations_GameDevHelperAPI_ComplexAnimation

-(void) dealloc
{
	[super dealloc];
}

-(NSString*)initTest
{
     CGSize s = [CCDirector sharedDirector].winSize;
    
#if 1
		// Use batch node. Faster
        //when using batches - load a batch node using the generated image
		batchNodeParent = [CCSpriteBatchNode batchNodeWithFile:@"RES_SheetAnimations_LoadAnimationTest/spriteSheetAnimationsTest_robotBlinking.png" capacity:100];
		[self addChild:batchNodeParent z:0];
#endif
        
    //load into the sprite frame cache the plist generated by SH
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"RES_SheetAnimations_LoadAnimationTest/spriteSheetAnimationsTest_robotBlinking.plist"];

    //using the GameDevHelper API animation cache - this will create GHAnimation objects - which are more complex then cocos2d animations
    GHAnimationCache *cache = [GHAnimationCache sharedAnimationCache];
    [cache addAnimationsWithFile:@"RES_SheetAnimations_LoadAnimationTest/spriteSheetAnimationsTest_SheetAnimations.plist"];//the animation exported plist file

    glClearColor(0.6, 0.6, 0.6, 1);
    
    [self executeTestCodeAtPosition:ccp(s.width/2, s.height/2)];

    return @"\n\n\n\n\nGameDevHelperAPI animations.\nDemonstrate random replay time.\nThe left robot will play normally,\nwhile the right robot plays with a random repeat time giving a more realistic look.\nWatch console for notifications.";
}

-(void)executeTestCodeAtPosition:(CGPoint)p
{    
    {
        //loading the sprite that will run the animation with random restart time
        GHSprite * spriteRandom = [GHSprite spriteWithSpriteFrameName:@"robotEyesOpen.png"];//the name of one of the sprite in the sheet plist
        
        if(batchNodeParent != nil){//if we use batch nodes we must add the sprite to its batch parent
            [batchNodeParent addChild:spriteRandom];
        }
        else{//if we dont use batch nodes then we must add the sprite to a normal node - e.g the layer or another node
            [self addChild:spriteRandom];
        }
        [spriteRandom setPosition:ccp(p.x + 60, p.y)];


        GHAnimationCache *cache = [GHAnimationCache sharedAnimationCache];
        GHAnimation *animation = [cache animationByName:@"blinkingAnim"];//the name of the animation
        
        [spriteRandom prepareAnimation:animation];
        [spriteRandom playAnimation];
        
        [spriteRandom setAnimationDelegate:self];
    }
    
    {
        //loading the sprite that will run the animation normal
        GHSprite * sprite = [GHSprite spriteWithSpriteFrameName:@"robotEyesOpen.png"];//the name of one of the sprite in the sheet plist
        
        if(batchNodeParent != nil){//if we use batch nodes we must add the sprite to its batch parent
            [batchNodeParent addChild:sprite];
        }
        else{//if we dont use batch nodes then we must add the sprite to a normal node - e.g the layer or another node
            [self addChild:sprite];
        }
        [sprite setPosition:ccp(p.x - 60, p.y)];
        
        //this is another way you can prepare an animation on a sprite
        [sprite prepareAnimationWithName:@"blinkingAnim"];
        [[sprite animation] setRandomReplay:NO];//MAKE RANDOM REPLAY FALSE - as this animation has random replay set to true (check SpriteHelper document)
        [sprite playAnimation];
    }
}

#pragma mark ANIMATION DELEGATE METHODS
-(void)animationDidFinishPlaying:(GHAnimation*)anim onSprite:(GHSprite*)sprite{
 
    NSLog(@"Animation %@ DID FINISH playing on sprite %@", [anim name], sprite);
}
-(void)animation:(GHAnimation*)anim didChangeFrameIdx:(NSInteger)frmIdx onSprite:(GHSprite*)sprite{
    
    NSLog(@"Animation %@ DID CHANGE FRAME %d on sprite %@", [anim name], (int)frmIdx, sprite);
}
-(void)animation:(GHAnimation*)anim didFinishRepetition:(NSInteger)repetitionNo onSprite:(GHSprite*)sprite{

    NSLog(@"Animation %@ DID FINISH REPETITION %d on sprite %@", [anim name], (int)repetitionNo, sprite);
}

@end









////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


#pragma mark - AppDelegate

#ifdef __CC_PLATFORM_IOS

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[super application:application didFinishLaunchingWithOptions:launchOptions];

	// Turn on display FPS
	[director_ setDisplayStats:YES];

	// Turn on multiple touches
	[director_.view setMultipleTouchEnabled:YES];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director_ setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

    
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// Assume that PVR images have the alpha channel premultiplied
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// If the 1st suffix is not found, then the fallback suffixes are going to used. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:YES];			// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// add layer
	CCScene *scene = [CCScene node];
	id layer = [TEST_CLASS node];
	[scene addChild:layer z:0];

	[director_ pushScene: scene];

	return YES;
}
     
@end

#elif defined(__CC_PLATFORM_MAC)

#pragma mark AppController - Mac

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[super applicationDidFinishLaunching:aNotification];

	// add layer
	CCScene *scene = [CCScene node];
	[scene addChild: [TEST_CLASS node] ];

	[director_ runWithScene:scene];
}
@end
#endif
