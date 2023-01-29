#include <iostream>
#include <cmath>

using namespace std;

int main() {
    double distance;
    double velocity;
    double hubble_constant = 70; // km/s/Mpc
    cout &#8203;`oaicite:{"index":0,"invalid_reason":"Malformed citation << \"Enter the distance to the galaxy in Mpc: \";\n    cin >>"}`&#8203; distance;
    velocity = hubble_constant * distance;
    cout << "The velocity of the galaxy is " << velocity << " km/s." << endl;
    return 0;
}
