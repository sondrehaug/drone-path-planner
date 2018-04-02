#include <iostream>
#include <vector>
#include <fstream>
#include <array>
#include <iomanip>
#include <list>
#include <string>
#include <algorithm>

using std::vector;
using namespace std;
// En funksjon som har paramtre og returverdi
// Sagt på en annen måte: En funksjon som tar inn argumenter og
// returnerer en verdi

struct Node {
	double x;
	double y;
	double g;
	double h;
	double f;
	bool obstacle;
	Node *parent;
	Node::Node() : x(0), y(0), g(1000), h(1000), f(1000), obstacle(0), parent(nullptr){

	};
	Node::Node(double x, double y) : x(x), y(y) {
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

int gScore(Node current, Node start) {
	int dx = 2 * fabs(start.x - current.x);
	int dy = 2 * fabs(start.y - current.y);
	int g = min(dx, dy) * 14 + abs(dx - dy) * 10;
	return g;
}

int hScore(Node current, Node end) {
	int dx = 2 * fabs(end.x - current.x);
	int dy = 2 * fabs(end.y - current.y);
	int h = min(dx, dy) * 14 + abs(dx - dy) * 10;
	return h;

};

void createGrid(Node (&grid)[11][11], Node End) {
	int rows = 11;
	int cols = 11;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			grid[i][j].x = 2.5 - (i*0.5);
			grid[i][j].y = 2.5 - (j*0.5);
			grid[i][j].h = hScore(grid[i][j],End);
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
		}
	}
	obstacleFile.close();
	
}

void Astar(Node (&grid)[11][11], Node Start, Node End) {
	int rows = 11;
	int cols = 11;
	list<Node> openList{};
	list<Node> closedList{};
	Start.g = 0;
	Start.h = hScore(Start, End);
	Start.f = Start.g + Start.h;
	openList.push_back(Start);
	Node current;
	int score;
	while (!(current == End)) {
		score = 1000;
		for (list<Node>::iterator it = openList.begin(); it != openList.end(); ++it) {
			if (it->f < score) {
				current = *it;
				score = it->f;
			}
		}
		cout << current.x << " " << current.y << endl;
		if (current.x == End.x && current.y == End.y) {
			cout << "Goal!!!";
			vector<double> path_x;
			vector<double> path_y;
				while (!(current == Start)) {
					path_x.push_back(current.x);
					path_y.push_back(current.y);
					cout << current.x << " " << current.y << endl;
					current = *current.parent;
				}
			
			ofstream pathFile("Path.txt");
			if (pathFile.is_open()) {
				for (int i = path_x.size()-1; i > -1; i--) {
					pathFile << path_x[i] << " " << path_y[i] << endl;
				}
			}
			pathFile.close();
			return;

		}
		openList.remove(current);
		closedList.push_back(current);
		current.g = gScore(current, Start);
		int tent_g = 0;
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
			list<Node>::iterator findIt = find(closedList.begin(), closedList.end(), (*neighbours)[i]);
			if (findIt == closedList.end()) {

				list<Node>::iterator findIt = find(openList.begin(), openList.end(), (*neighbours)[i]);
				if (findIt == openList.end()) {

					tent_g = current.g + gScore((*neighbours)[i], current);
					int x = int(2 * (2.5 - (*neighbours)[i].x));
					int y = int(2 * (2.5 - (*neighbours)[i].y));
					if (tent_g < ((*neighbours)[i].g)) {
						grid[x][y].parent = &grid[int(2 * (2.5 - (current.x)))][int(2 * (2.5 - (current.y)))];
						grid[x][y].g = tent_g;
						grid[x][y].f = (grid[x][y].g + hScore((*neighbours)[i], End));
					}
					openList.push_back(grid[x][y]);
				}
			}
		}
		delete neighbours;
	}
}
void main() {

	Node grid[11][11];
	Node End(2, 0);
	createGrid(grid, End);
	for (int i = 0; i < 11; i++) {
		for (int j = 0; j < 11; j++) {
			cout << setw(6) << grid[i][j].obstacle;
		}
		cout << "\n" << "\n";
	}
	Node Start = grid[8][2];
	Node MidPoint = grid[1][5];
	Node Goal = grid[8][8];
	Astar(grid, Start, MidPoint);
}