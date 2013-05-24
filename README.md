BRScrollBar
===========

BRScrollBarView is a powerful scroll bar allows the user to drag a handle to faster scroll a UIScrollView or UITableView.
BRScollBarView has a great feature, shows a label with text, so you don’t need to add indexed bar on table views or scroll views.  

Screenshots:
===================
1. BRScrollBar from left<br>
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.50.02%20PM.png" alt="brscrollbar from left" height="330" width="240" >

2. BRScrollBar from right<br>
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.46.21%20PM.png"  height="330" width="240">

3. BRScrollBar is customizable<br>
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.53.56%20PM.png" height="330" width="240">
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.52.45%20PM.png" height="330" width="240">
<img src="https://dl.dropboxusercontent.com/u/59060791/BRScollBar%20Images/iOS%20Simulator%20Screen%20shot%20May%2024%2C%202013%2012.52.03%20PM.png" height="330" width="240">

What Will you need:
===================
1. iOS 5-6
2. ARC
3. BRScrollView classes

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
