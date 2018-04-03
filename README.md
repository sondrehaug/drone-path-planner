# drone-path-planner

## How to run the code ##
-------------------------
1. Enter the folder where you want to clone the repostory:
	```bash
	$ cd your-path
	```

2. Clone the repository: 
	```bash
	$ git clone https://github.com/sondrehaug/drone-path-planner
	```

3. Inside your workspace where you cloned the repostory. Compile the A-star code:
	```bash
	$g++ --std=c++11 -o Astar Astar.cpp
	```
And execute the file:
	
	```bash
	$./Astar
	```

This will generate the file coordinates.txt, which the MATLAB files will use to generate a path

4. Open MATLAB and go to the folder containing the files

5. Run calc_all in the command window

6. Launch simulator
