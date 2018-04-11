#include <iostream>
#include <vector>
#include <fstream>
#include <array>
#include <iomanip>
#include <list>
#include <string>
#include <algorithm>
//#include <Windows.h>
//#include <SFML\Graphics.hpp>

#include <cstdlib>
#include <ctime>
#include <iostream>
//#include "Minesweeper.h"

using std::vector;
using namespace std;

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
/*
const sf::Color open_fill_color = sf::Color::Green, closed_fill_color(192, 192, 192);
const sf::Color number_colors[9] = {
	sf::Color::White,
	sf::Color::Blue,
	sf::Color(0, 128, 0),
	sf::Color::Red,
	sf::Color(0, 0, 128),
	sf::Color(128, 0, 0),
	sf::Color(0, 128, 128),
	sf::Color::Black,
	sf::Color(128, 128, 128)
};
const sf::Color mine_color = sf::Color::Red;
const sf::Color obstacle_color = sf::Color::Black;
const sf::Color closedList_fill_color = sf::Color::Green;
const sf::Color openList_fill_color = sf::Color::Red;
*/
const int tile_size = 96;
const int border_size = 2;

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
			grid[x_pos + 1][y_pos].obstacle = true;
			grid[x_pos - 1][y_pos].obstacle = true;
			grid[x_pos][y_pos + 1].obstacle = true;
			grid[x_pos][y_pos - 1].obstacle = true;
		}
	}
	obstacleFile.close();
}

void Astar(Node(&grid)[11][11], Node Start, Node End) {
	int count = 0;
	int rows = 11;
	int cols = 11;
	list<Node> openList{};
	list<Node> closedList{};
	Start.g = 0;
	Start.h = hScore(Start, End);
	Start.f = Start.g + Start.h;
	int i = 2 * (2.5 - Start.x);
	int j = 2 * (2.5 - Start.y);
	grid[i][j].g = Start.g;
	grid[i][j].f = Start.f;
	openList.push_back(Start);
	Node current;
	int score;
	while (!(current == End)) {
		score = 1000;
		if (current.x == 1.5 && current.y == 0) {
			int test = 0;
		}
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
			openList.remove(current);
			closedList.push_back(current);
			count++;
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
			if (pathFile.is_open()) {
				for (int i = path_x.size() - 1; i > -1; i--) {
					pathFile << path_x[i] << " " << path_y[i] << endl;
				}
			}
			/*
			srand(time(nullptr));
			sf::Font font;
			int height = 11, width = 11, mines = 0;
			sf::RenderWindow window(sf::VideoMode(width * tile_size, height * tile_size), "A* algorithm", sf::Style::Close);
			window.setFramerateLimit(60);
			window.clear();
			for (int row = 0; row < height; ++row) {
				for (int col = 0; col < width; ++col) {
					const int tile_x = col * tile_size, tile_y = row * tile_size;
					sf::RectangleShape tile;
					sf::Text text;
					tile.setSize(sf::Vector2f(tile_size - border_size, tile_size - border_size));
					tile.setFillColor(!grid[row][col].obstacle ? closed_fill_color : obstacle_color);
					list<Node>::iterator findclosed = find(closedList.begin(), closedList.end(), grid[row][col]);
					if (findclosed != closedList.end()) {
						tile.setFillColor(closedList_fill_color);
					}
					list<Node>::iterator findopen = find(openList.begin(), openList.end(), grid[row][col]);
					if (findopen != openList.end()) {
						tile.setFillColor(openList_fill_color);
					}
					for (int i = 0; i < path_x.size(); i++) {
						if (grid[row][col].x == path_x[i] && grid[row][col].y == path_y[i]) {
							tile.setFillColor(sf::Color::Blue);
						}
						if (grid[row][col].x == Start.x && grid[row][col].y == Start.y) {
							tile.setFillColor(sf::Color::Blue);
						}
					}
					tile.setPosition(tile_x + border_size / 2.0, tile_y + border_size / 2.0);
					window.draw(tile);
					list<Node>::iterator findOpen = find(openList.begin(), openList.end(), grid[row][col]);
					list<Node>::iterator findClosed = find(closedList.begin(), closedList.end(), grid[row][col]);
					if (findOpen != openList.end() || findClosed != closedList.end()) {
						sf::Text text;
						sf::Text h_value;
						sf::Text g_value;
						sf::Text f_value;
						text.setCharacterSize(tile_size / 4.0);
						sf::Font font;
						font.loadFromFile("arial.ttf");
						text.setFont(font);
						text.setFillColor(sf::Color::Black);
						text.setStyle(sf::Text::Bold);
						h_value = text;
						g_value = text;
						f_value = text;
						h_value.setPosition(tile_x + tile_size / 11 + border_size / 2.0, tile_y + border_size / 2.0);
						h_value.setString(to_string(int(grid[row][col].h)));
						g_value.setPosition(tile_x + tile_size / 1.5, tile_y + border_size / 2.0);
						g_value.setString(to_string(int(grid[row][col].g)));
						f_value.setPosition(tile_x + (tile_size / 2.75) + border_size / 2.0, tile_y + tile_size / 2.5 + border_size / 2.0);
						f_value.setString(to_string(int(grid[row][col].f)));
						window.draw(h_value);
						window.draw(g_value);
						window.draw(f_value);
					}
				}
			}
			window.display();
			while (window.isOpen()) {
				sf::Event event;
				while (window.pollEvent(event)) {
					switch (event.type) {
					case sf::Event::Closed:
						window.close();
						break;
					case sf::Event::KeyPressed:

						switch (event.key.code) {
						case sf::Keyboard::Escape:
						case sf::Keyboard::Q:
							window.close();
							break;

						}
					}

				}
			}*/
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
				tent_g = current.g + gScore((*neighbours)[i], current);
				int x = int(2 * (2.5 - (*neighbours)[i].x));
				int y = int(2 * (2.5 - (*neighbours)[i].y));
				if (tent_g < ((*neighbours)[i].g)) {
					grid[x][y].parent = &grid[int(2 * (2.5 - (current.x)))][int(2 * (2.5 - (current.y)))];
					grid[x][y].g = tent_g;
					grid[x][y].f = (grid[x][y].g + hScore((*neighbours)[i], End));
				}
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
		/*
		srand(time(nullptr));
		sf::Font font;
		int height = 11, width = 11, mines = 0;
		sf::RenderWindow window(sf::VideoMode(width * tile_size, height * tile_size), "A* algorithm", sf::Style::Close);
		window.setFramerateLimit(60);		
		window.clear();
		for (int row = 0; row < height; ++row) {
			for (int col = 0; col < width; ++col) {
				const int tile_x = col * tile_size, tile_y = row * tile_size;
				sf::RectangleShape tile;
				sf::Text text;
				tile.setSize(sf::Vector2f(tile_size - border_size, tile_size - border_size));
				tile.setFillColor(!grid[row][col].obstacle ? closed_fill_color : obstacle_color);
				list<Node>::iterator findclosed = find(closedList.begin(), closedList.end(), grid[row][col]);
				if (findclosed != closedList.end()) {
					tile.setFillColor(closedList_fill_color);	
					text.setStyle(sf::Text::Bold);
					text.setCharacterSize(tile_size / 4.0);
					text.setFillColor(obstacle_color);
					text.setString(to_string(grid[row][col].f));
					text.setPosition(tile_x + tile_size / 2.0, tile_y + tile_size / 2.0);		
				}
				list<Node>::iterator findopen = find(openList.begin(), openList.end(), grid[row][col]);
				if (findopen != openList.end()) {
					tile.setFillColor(openList_fill_color);
				}
				tile.setPosition(tile_x + border_size / 2.0, tile_y + border_size / 2.0);
				window.draw(tile);
				list<Node>::iterator findOpen = find(openList.begin(), openList.end(), grid[row][col]);
				list<Node>::iterator findClosed = find(closedList.begin(), closedList.end(), grid[row][col]);
				if (findOpen != openList.end() || findClosed != closedList.end()) {
					sf::Text text;
					sf::Text h_value;
					sf::Text g_value;
					sf::Text f_value;
					text.setCharacterSize(tile_size / 4.0);
					sf::Font font;
					font.loadFromFile("arial.ttf");
					text.setFont(font);
					text.setFillColor(sf::Color::Black);
					text.setStyle(sf::Text::Bold);
					h_value = text;
					g_value = text;
					f_value = text;
					h_value.setPosition(tile_x + tile_size / 11 + border_size / 2.0, tile_y + border_size / 2.0);
					h_value.setString(to_string(int(grid[row][col].h)));
					g_value.setPosition(tile_x + tile_size / 1.5, tile_y + border_size / 2.0);
					g_value.setString(to_string(int(grid[row][col].g)));
					f_value.setPosition(tile_x + (tile_size / 2.75) + border_size / 2.0, tile_y + tile_size / 2.5 + border_size / 2.0);
					f_value.setString(to_string(int(grid[row][col].f)));
					
					window.draw(h_value);
					window.draw(g_value);
					window.draw(f_value);
				}
				
				
			}
		}
		window.display();
		
		while (window.isOpen()) {
			sf::Event event;
			while (window.pollEvent(event)) {
				switch (event.type) {
				case sf::Event::Closed:
					window.close();
					break;
				case sf::Event::KeyPressed:

					switch (event.key.code) {
					case sf::Keyboard::Escape:
					case sf::Keyboard::Q:
						window.close();
						break;

					}
				}

			}
		}*/
		//Sleep(3000);
	}

}


int main() {
	Node grid[11][11];
	Node Beginning(-1.5, 1.5);
	Node End(2, 0);
	createGrid(grid, End, Beginning);
	Node Start = grid[8][2];
	Node MidPoint = grid[1][5];
	Node Goal = grid[8][8];
	ofstream pathFinder("coordinates.txt");
	pathFinder << Start.x << " " << Start.y << endl;
	pathFinder.close();
	Astar(grid, Start, MidPoint);
	Beginning = Node(2, 0);
	End = Node(-1.5, -1.5);
	createGrid(grid, End, Beginning);
	cout << "Calculating new path" << endl;
	Astar(grid, MidPoint, Goal);
	return 0;
}