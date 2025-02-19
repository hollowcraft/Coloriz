### ====================================================================================================
### IMPORTS
### ====================================================================================================#
import math
import random

import arcade
import arcade.key

from utils import *

from random import randint

class Process:
    ### ====================================================================================================
    ### PARAMETERS
    ### ====================================================================================================
    SCREEN_WIDTH = int(1920 * 0.75)
    SCREEN_HEIGHT = int(1080 * 0.75)


    ### ====================================================================================================
    ### CONSTRUCTOR
    ### ====================================================================================================
    def __init__(self):
        pass

    def createItem(self):
        x = 20*randint(0, Process.SCREEN_WIDTH/20)
        y = Process.SCREEN_HEIGHT
        idx = randint(0, 17)
        settings = {
            'filePath'  : 'images/items/gems.png',
            'size'      : (Process.SCREEN_WIDTH / 10, Process.SCREEN_HEIGHT / 10),
            'position'  : (x, y),
            'spriteBox' : (6, 3, 100, 100),
            'startIndex': idx,
            'endIndex'  : idx
        }
        tmp = createAnimatedSprite(settings)
        tmp.angle += randint(-10, 10)
        self.itemList.append(tmp)

    def createAnim(self, x, y):
        settings = {
            'filePath'     : 'images/items/splash.png',
            'size'         : (Process.SCREEN_WIDTH / 10, Process.SCREEN_HEIGHT / 10),
            'position'     : (x, y),
            'spriteBox'    : (8, 1, 192, 96),
            'startIndex'   : 1,
            'endIndex'     : 8,
            'frameDuration': 1 / 10
        }
        self.splash = createAnimatedSprite(settings)


    def collitionCircle(self, x1,y1,r1, x2,y2,r2):
        dx = x1 - x2
        dy = y1 - y2
        d = math.sqrt(dx**2 + dy**2)
        print(d,r1,r2)
        return d < r1 + r2

    ### ====================================================================================================
    ### SETUP
    ### ====================================================================================================
    def setup(self):
        self.moveLeft = False
        self.moveRight = False
        self.moveDown = False
        self.mvsp = 10
        self.state = 'normal'
        self.gem = 0

        self.itemList = []
        self.chrono = 0

        self.idX = 10

        self.createAnim(0,0)

        self.debug = False

        settings = {
            'filePath'  : 'images/characters/penguin_fix.png',
            'size'      : (Process.SCREEN_WIDTH/7, Process.SCREEN_HEIGHT/7),
            'position'  : (Process.SCREEN_WIDTH/2, Process.SCREEN_HEIGHT/4)
        }
        self.player = createFixedSprite(settings)
        self.player2 = createFixedSprite(settings)

        settings = {
            'filePath'     : 'images/characters/penguin.png',
            'size'         : (Process.SCREEN_WIDTH / 7, Process.SCREEN_HEIGHT / 7),
            'position'     : (Process.SCREEN_WIDTH / 2, Process.SCREEN_HEIGHT / 4),
            'spriteBox'    : (5, 1, 250, 250),
            'startIndex'   : 0,
            'endIndex'     : 3,
            'frameDuration': 1 / 15,
            'flipH'        : False
        }
        self.playerAnim = createAnimatedSprite(settings)

        settings = {
            'filePath': 'images/backgrounds/winter.png',
            'size'    : (Process.SCREEN_WIDTH, Process.SCREEN_HEIGHT),
            'position': (Process.SCREEN_WIDTH / 2, Process.SCREEN_HEIGHT / 2)
        }
        self.back = createFixedSprite(settings)

        settings = {
            'filePath': 'images/items/gems.png',
            'size': (Process.SCREEN_WIDTH / 10, Process.SCREEN_HEIGHT / 10),
            'spriteBox': (6, 3, 100, 100),
            'startIndex': self.idX,
            'endIndex': self.idX
        }
        self.sGem = createAnimatedSprite(settings)

    ### ====================================================================================================
    ### UPDATE
    ### ====================================================================================================
    def update(self, deltaTime):
        if self.state == 'normal':
            if self.moveLeft:
                self.player.center_x -= self.mvsp
                self.player.width = -Process.SCREEN_WIDTH/12
                self.mvsp += 0.2
            if self.moveRight:
                self.player.center_x += self.mvsp
                self.player.width = Process.SCREEN_WIDTH/12
                self.mvsp += 0.2
            if self.moveRight == self.moveLeft:
                self.mvsp = 10

            if self.moveDown:
                self.state = 'dash'
                if self.moveLeft:
                    self.mvsp = 1
                if self.moveRight:
                    self.mvsp = -1
                self.dashTime = 400
            #self.player2.texture = self.player.texture

        if self.state == 'dash':
            if self.dashTime <= 0:
                self.dashTime -= 1
                self.player.center_x -= self.dashSpeed * self.mvsp
            else:
                self.state = 'normal'




        self.chrono += deltaTime
        if self.chrono >= 0.5:
            self.chrono = 0
            self.createItem()

        self.limit0 = 0 #- abs(self.player.width /2)
        self.limit1 = Process.SCREEN_WIDTH #+ abs(self.player.width) /2
        if self.player.center_x < self.limit0:
            self.player.center_x = self.limit1
        if self.player.center_x > self.limit1:
            self.player.center_x = self.limit0

        self.playerAnim.update_animation(deltaTime)
        self.splash.update_animation(deltaTime)
        self.playerAnim.center_x = self.player.center_x

        x1 = self.player.center_x
        y1 = self.player.center_y
        r1 = abs(self.player.width/4)
        for itm in self.itemList:
            itm.center_y -= 10
            if itm.center_y < self.SCREEN_HEIGHT/7.5:
                self.itemList.remove(itm)
                self.createAnim(itm.center_x, itm.center_y)
                self.gem -= 0
            if itm.center_y < self.SCREEN_HEIGHT/3.4:
                itm.angle += 5
            x2 = itm.center_x
            y2 = itm.center_y
            r2 = itm.width / 2.5
            if self.collitionCircle(x1,y1,r1 ,x2,y2,r2):
                self.itemList.remove(itm)
                self.gem += 1

        settings = {
            'filePath': 'images/items/gems.png',
            'size': (Process.SCREEN_WIDTH / 10, Process.SCREEN_HEIGHT / 10),
            'spriteBox': (6, 3, 100, 100),
            'startIndex': self.idX,
            'endIndex': self.idX
        }
        self.sGem = createAnimatedSprite(settings)

    ### ====================================================================================================
    ### RENDERING
    ### ====================================================================================================
    def draw(self):
        self.back.draw()
        if self.moveLeft:
            self.playerAnim.width = -120
        if self.moveRight:
            self.playerAnim.width = 120
        if self.moveLeft == self.moveRight:
            self.player.draw()
        else:
            self.playerAnim.draw()
        for itm in self.itemList:
            itm.draw()
            if self.debug == True:
                arcade.draw_circle_filled(itm.center_x,itm.center_y,itm.width/2.5,(0,255,255,127))

        self.player2.center_x = self.player.center_x
        self.player2.width = self.player.width
        self.player2.center_x += self.SCREEN_WIDTH
        self.player2.draw()
        self.player2.center_x -= 2*self.SCREEN_WIDTH
        self.player2.draw()
        self.player2.center_x += self.SCREEN_WIDTH

        self.splash.draw()

        if self.debug == True:
            arcade.draw_circle_filled(self.player.center_x, self.player.center_y, self.player.width/4, (0, 255, 255, 127))

        self.sGem.center_x = 50
        self.sGem.center_y = Process.SCREEN_HEIGHT - 50

        for i in range(self.gem):
            self.idX = int(self.gem/10)
            self.sGem.draw()
            self.sGem.center_x += 100
            self.sGem.center_x -= int(self.sGem.center_x/1000)

    ### ====================================================================================================
    ### KEYBOARD EVENTS
    ### key is taken from : arcade.key.xxx
    ### ====================================================================================================
    def onKeyEvent(self, key, isPressed):
        if key == 65361:
            self.moveLeft = isPressed
        if key == 65363:
           self.moveRight = isPressed
        if key == arcade.key.DOWN:
            self.moveDown = isPressed
        if key == arcade.key.TAB and isPressed:
            if self.debug == False:
                self.debug = True
            else:
                self.debug = False


    ### ====================================================================================================
    ### GAMEPAD BUTTON EVENTS
    ### buttonName can be "A", "B", "X", "Y", "LB", "RB", "VIEW", "MENU", "LSTICK", "RSTICK"
    ### ====================================================================================================
    def onButtonEvent(self, gamepadNum, buttonName, isPressed):
        pass

    ### ====================================================================================================
    ### GAMEPAD AXIS EVENTS
    ### axisName can be "X", "Y", "RX", "RY", "Z"
    ### ====================================================================================================
    def onAxisEvent(self, gamepadNum, axisName, analogValue):
        pass

    ### ====================================================================================================
    ### MOUSE MOTION EVENTS
    ### ====================================================================================================
    def onMouseMotionEvent(self, x, y, dx, dy):
        pass
    ### ====================================================================================================
    ### MOUSE BUTTON EVENTS
    ### ====================================================================================================
    def onMouseButtonEvent(self, x, y, buttonNum, isPressed):
        pass
