# Unit 6 Assignment: CICT Org Fair Part 2

Name: Roland Shem Alera
Section: BSIT 3-B

## E1: Lifting state up
So the joined are stored in _memberships at home_shell,dart in line 25, because three screens need the same data. OrgListScreen shows which orgs you joined, MyOrgsScreen lists them, and ScheduleScreen highlights their rows. If one screen kept the map, the others couldn't read it, since siblings widgets can't see each other's state. So the data is lifted to their common parent, which passes it down and updates it through _join and _leave using setState.
## E2: IndexedStack
The IndexStack builds all three pages and keeps them in the widget tree, but shows only the one at index. Because the Orgs is never disposed, its State including the search text and controller, stays alive. With pages _index the old screen is go away on every tab switch, so the search box would be empty when you return. 


## E3: Closing the drawer
The drawer sits on top of the Navigator stack as its own layer. If pushNamed (line 135) ran without Navigator.pop (line 134), the About screen would open above the still-open drawer. Pressing back from About would then show the open drawer instead of the list. Closing the drawer first leaves a clean stack, so back returns directly to the list.

## E4: Wrap or Row
When the chips don’t fit on one line, Wrap moves the extra chips down to the next line, so every chip stays visible. A Row keeps all the chips on one line and can’t wrap or scroll, so the ones that don’t fit run past the screen edge. In Experiment C2, I replaced Wrap with Row and narrowed the window. The “Service” chip was cut off and Flutter showed the yellow-black overflow stripes (“overflowed by 41 pixels”). With Wrap, the chip moved to a second line.



## E5: maxCrossAxisExtent
The number of columns is ceil(usable width ÷ (200 + 8)), where 8 is the spacing (line 301) and the usable width is the screen width minus the 8 padding on each side (line 290). A 360-wide phone has 344 usable, and 344 ÷ 208 = 1.65 rounds up to 2 columns, each (344 − 8) ÷ 2 = 168 wide. A 1000-wide window has 984 usable, and 984 ÷ 208 = 4.73 rounds up to 5 columns, each (984 − 4 × 8) ÷ 5 ≈ 190 wide. I checked this in Chrome (Experiment C5): the grid showed 4 columns in a narrow window and 8 in a wide one, so the width decides the columns

## E6: DefaultTabController, TabBar and TabBarView
The three numbers must be equal. length: 3 is on line 36, the TabBar has 3 Tabs (lines 42 to 44), and the TabBarView has 3 children (lines 50 to 52), in the same order, so each tab opens its own page. If they don’t match, Flutter throws an error such as “Controller’s length property does not match the number of tabs” and the screen shows the red error screen instead of working tabs.

## E7: Dialog bool?
The three numbers must be equal. length: 3 is on line 36, the TabBar has 3 Tabs (lines 42 to 44), and the TabBarView has 3 children (lines 50 to 52), in the same order, so each tab opens its own page. If they don’t match, Flutter throws an error such as “Controller’s length property does not match the number of tabs” and the screen shows the red error screen instead of working tabs.

## E8: Table
A Table gives each column one width that all rows share (set in columnWidths, lines 53 to 57), so Time, Booth and Org line up in every row. In a Column of Rows, each row would size its own cells, so a longer org name would push its cells over and the columns would drift out of line between rows.