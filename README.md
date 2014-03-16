BRScrollBar
===========

BRScrollBarView is a powerful scroll bar allows the user to drag a handle to faster scroll a UIScrollView or UITableView.
BRScollBarView has a great feature,that shows a label with text, so you don’t need to add indexed bar on your table views or on scroll views.  

Screenshots:
===================
1. BRScrollBar from left<br>
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.50.02%20PM.png" alt="brscrollbar from left" height="330" width="240" >

2. BRScrollBar from right<br>
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.46.21%20PM.png"  height="330" width="240">

3. BRScrollBar is customizable<br>
[[https://github.com/BasheerSience/BRScrollBar/blob/master/DemoGif.gif]]
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.53.56%20PM.png" height="330" width="240">
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.52.45%20PM.png" height="330" width="240">
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.52.03%20PM.png" height="330" width="240">

What Will you need:
===================
1. iOS 5-7
2. ARC
3. BRScrollView classes
4. QuartzCore framework

How to Use it:
==================
<b>1. You can call class method like this:</b>

```Objective-C
    [BRScrollBarController initForScrollView:self.tableView
                                  onPosition:kIntBRScrollBarPositionRight
                                    delegate:self];
``` 

<b>2. Or instance method like this:</b>

```Objective-C
    [[BRScrollBarController alloc] initForScrollView:self.tableView
                                          inPosition:kIntBRScrollBarPositionLeft];
    // dont forget to set the delegate, if you want to show the label with text
```
<b>3. Change the the bar and the handle color:</b>

```Objective-C
    BRScrollBarController *brScrollbar = [BRScrollBarController initForScrollView:self.tableView
                                                            onPosition:kIntBRScrollBarPositionRight
                                                              delegate:self];
    brScrollbar.scrollBar.backgroundColor = [UIColor purpleColor]; 
    brScrollbar.scrollHandle.backgroundColor = [UIColor lightGray];
    brScrollbar.scrollHandle.alpha = 0.5;
    brScrollbar.scrollLabel.backgroundColor = [UIColor whiteColor];
```
<b>4. Respond to BRScrollBarController delegate to add text to the label</b>

```Objective-C
- (NSString *)brScrollBarController:(BRScrollBarController *)controller textForCurrentPosition:(CGPoint)position
{
    NSIndexPath *index = [self.tableView indexPathForRowAtPoint:position];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    
    return cell.textLabel.text;
}
```
<b>5. To stop showing the label call this:</b>
```Objective-C
brScrollbar.scrollBar.showLabel = NO;
```
<b>6. To keep the scrollbar always visible, do this:</b>
```Objective-C
brScrollBar.scrollBar.hideScrollBar = NO;
```


Lincense:
==========
Copyright (c) 2013 Basheer Malaa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
