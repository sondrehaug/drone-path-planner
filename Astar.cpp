#include <iostream>
#include <vector>
#include <fstream>
#include <array>
#include <iomanip>
#include <list>
#include <string>
#include <algorithm>

//#include <Windows.h>

using std::vector;

using namespace std;



// Creating a node with information on x-, y- and z-coordinates,

// g-, h- and f-cost, if it is an obstacle and the parent of the node

struct Node {

	double x;

	double y;

	double g;

	double h;

	double f;

	bool obstacle;

	Node *parent;



	Node() : x(0), y(0), g(1000), h(1000), f(1000), obstacle(0), parent(nullptr) {



	};

	Node(double x, double y) : x(x), y(y) {

		this->obstacle = false;

	};

	bool operator==(const Node& rhs) const {

		if (this->x == rhs.x && this->y == rhs.y) {

			return true;

		}

		return false;

	}

	Node operator=(const Node& rhs) {

		this->x = rhs.x;

		this->y = rhs.y;

		this->f = rhs.f;

		this->g = rhs.g;

		this->h = rhs.h;

		this->obstacle = rhs.obstacle;

		this->parent = rhs.parent;



		return *this;

	}

};



// Calculate the gScore as distance from the start point

int gScore(Node current, Node start) {

	int dx = 2 * fabs(start.x - current.x);

	int dy = 2 * fabs(start.y - current.y);

	int g = min(dx, dy) * 14 + abs(dx - dy) * 10;

	return g;

}



// Calculate the hScore as distance from end point

int hScore(Node current, Node end) {

	int dx = 2 * fabs(end.x - current.x);

	int dy = 2 * fabs(end.y - current.y);

	int h = min(dx, dy) * 14 + abs(dx - dy) * 10;

	return h;



};





// Create grid of obstacles

void createGrid(Node(&grid)[11][11], Node End, Node Start) {

	int rows = 11;

	int cols = 11;

	for (int i = 0; i < rows; i++) {

		for (int j = 0; j < cols; j++) {

			grid[i][j].x = 2.5 - (i*0.5);

			grid[i][j].y = 2.5 - (j*0.5);

			grid[i][j].h = hScore(grid[i][j], End);

			grid[i][j].g = 1000;

			grid[i][j].f = grid[i][j].h + grid[i][j].g;



			grid[i][j].obstacle = false;

		}

	}

	string line;

	string x;

	string y;

	ifstream obstacleFile("obstacles.txt");

	if (obstacleFile.is_open()) {

		while (getline(obstacleFile, line)) {

			int i = 0;

			x = "";

			y = "";

			while (line[i] != ' ') {

				x += line[i];

				i++;

			}

			i++;

			while (line[i] != '\0') {

				y += line[i];

				i++;

			}

			int x_pos = 2 * (2.5 - (stod(x)));

			int y_pos = 2 * (2.5 - (stod(y)));

			grid[x_pos][y_pos].obstacle = true;

			if ( x_pos < ( rows-1 ) )
				grid[x_pos + 1][y_pos].obstacle = true;

			if ( x_pos > 0 )
				grid[x_pos - 1][y_pos].obstacle = true;

			if ( y_pos < ( cols - 1 ) )
				grid[x_pos][y_pos + 1].obstacle = true;

			if ( y_pos > 0 )
				grid[x_pos][y_pos - 1].obstacle = true;
				
		}

	}

	obstacleFile.close();



}



// A* search algorithm

void Astar(Node(&grid)[11][11], Node Start, Node End) {

	int count = 0;

	int rows = 11;

	int cols = 11;



	// A list of discovered nodes that are not evaluated

	list<Node> openList{};

	// A list of already evaluated nodes

	list<Node> closedList{};

	// g-,h- and f-score of the start point

	Start.g = 0;

	Start.h = hScore(Start, End);

	Start.f = Start.g + Start.h;

	openList.push_back(Start);

	Node current;

	int score;



	// Runs until the end position is reached

	while (!(current == End)) {

		score = 1000;

		for (list<Node>::iterator it = openList.begin(); it != openList.end(); ++it) {

			if (it->f == score) {

				if (it->h < current.h)

					current = *it;

			}

			if (it->f < score) {

				current = *it;

				score = it->f;

			}

		}

		cout << current.x << " " << current.y << endl;

		if (current.x == End.x && current.y == End.y) {

			

			cout << "Goal!!!" << endl;

			vector<double> path_x;

			vector<double> path_y;

			while (!(current == Start)) {

				path_x.push_back(current.x);

				path_y.push_back(current.y);

				cout << current.x << " " << current.y << endl;

				current = *current.parent;

			}

			ofstream pathFile;

			pathFile.open("coordinates.txt", ofstream::app);

			// Writes to the file coordinates.txt

			if (pathFile.is_open()) {

				for (int i = path_x.size() - 1; i > -1; i--) {

					pathFile << path_x[i] << " " << path_y[i] << endl;

				}

			}



			return;



		}

		openList.remove(current);

		closedList.push_back(current);

		current.g = gScore(current, Start);

		int tent_g = 0;



		// Creates a vector of neighbours that are not obstacles

		vector<Node>* neighbours = new vector<Node>(0);

		int i = 2 * (2.5 - current.x);

		int j = 2 * (2.5 - current.y);

		if (i < cols - 1 && grid[i + 1][j].obstacle == false) {

			neighbours->push_back(grid[i + 1][j]);

		}

		if (i > 0 && grid[i - 1][j].obstacle == false) {

			neighbours->push_back(grid[i - 1][j]);

		}



		if (j < rows - 1 && grid[i][j + 1].obstacle == false) {

			neighbours->push_back(grid[i][j + 1]);

		}

		if (j > 0 && grid[i][j - 1].obstacle == false) {

			neighbours->push_back(grid[i][j - 1]);

		}



		if (i > 0 && j > 0 && grid[i - 1][j - 1].obstacle == false) {

			neighbours->push_back(grid[i - 1][j - 1]);

		}

		if (i > 0 && j < rows - 1 && grid[i - 1][j + 1].obstacle == false) {

			neighbours->push_back(grid[i - 1][j + 1]);

		}

		if (i < cols - 1 && j > 0 && grid[i + 1][j - 1].obstacle == false) {

			neighbours->push_back(grid[i + 1][j - 1]);

		}

		if (i < cols - 1 && j < rows - 1 && grid[i + 1][j + 1].obstacle == false) {

			neighbours->push_back(grid[i + 1][j + 1]);

		}

		for (int i = 0; i < neighbours->size(); i++) {

			// Checks if the neighbour is in the closedList: if the node is already evaluated

			list<Node>::iterator findIt = find(closedList.begin(), closedList.end(), (*neighbours)[i]);

			if (findIt == closedList.end()) {



				// The distance from start to a neigbour

				tent_g = current.g + gScore((*neighbours)[i], current);

				int x = int(2 * (2.5 - (*neighbours)[i].x));

				int y = int(2 * (2.5 - (*neighbours)[i].y));

				if (tent_g < ((*neighbours)[i].g)) {

					// This is a better path

					grid[x][y].parent = &grid[int(2 * (2.5 - (current.x)))][int(2 * (2.5 - (current.y)))];

					grid[x][y].g = tent_g;

					grid[x][y].f = (grid[x][y].g + hScore((*neighbours)[i], End));

				}

				// Checks if the node is in openList: if the node has been discovered but not evaluated

				list<Node>::iterator findIt = find(openList.begin(), openList.end(), (*neighbours)[i]);

				if (findIt == openList.end()) {

					openList.push_back(grid[x][y]);

				}
				else {
					openList.erase(findIt);
					openList.push_back(grid[x][y]);
				}

			}

		}

		delete neighbours;

		//sleep(1000);

	}

}

int main() {



	// Initilizing the grid

	Node grid[11][11];

	Node Beginning(-1.5, 1.5);

	Node End(2, 0);

	createGrid(grid, End, Beginning);

	for (int i = 0; i < 11; i++) {

		for (int j = 0; j < 11; j++) {

			cout << setw(6) << grid[i][j].obstacle;

		}

		cout << "\n" << "\n";

	}

	// Using A* search algorithm from start point to the midway point

	Node Start = grid[8][2];

	Node MidPoint = grid[1][5];

	Node Goal = grid[8][8];



	// Delete previous points in file

	ofstream pathFinder("coordinates.txt");
	pathFinder << Start.x << " " << Start.y << endl;
	pathFinder.close();

	Astar(grid, Start, MidPoint);



	// Using A* search algorithm from midway point to the goal point

	Beginning = Node(2, 0);

	End = Node(-1.5, -1.5);

	createGrid(grid, End, Beginning);

	cout << "Calculating new path" << endl;

	Astar(grid, MidPoint, Goal);

	return 0;

}
