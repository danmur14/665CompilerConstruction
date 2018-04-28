/*
    Daniel Murga
    EECS 665
    NFA to DFA
*/
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <algorithm>
#include <set>
#include <map>
#include <vector>

using namespace std;

vector<string> alphabet; //alphabet for nfa and dfa

/*NFA*/
vector<int> nfaInitStates;
map<int, map<string, vector<int>>> nfa; //nfa[1][E] = <2,5>
vector<int> nfaFinalStates;

/*DFA*/
int dfaInitStates = 1; //initial state for dfa
map<int, map<string, int>> dfa; //dfa[1][a] = 2
map<int, set<int>> dfaClosed; //maps dfa states to corresponding nfa states
set<set<int>> Dstates; //easy way to check for unique dfa states
set<int> dfaFinalStates; //list of unique final dfa states

//prints int vector {a,b,c}
void printvec(vector<int> vec)
{
    cout << "{";
    for (unsigned int i = 0; i < vec.size(); i++)
    {
        cout << vec[i];
        if(i != vec.size() - 1)
        {
            cout << ",";
        }
    }
    cout << "}";
}

//prints int set {a,b,c}
void printset(set<int> s)
{
    set<int>::iterator it = s.begin();
    cout << "{";
    while(it != s.end())
    {
        cout << *it;
        it++;
        if(it != s.end())
        {
            cout << ",";
        }
    }
    cout << "}";
}

//prints formatted results to console
void printResults()
{
    cout << "Initial State: {" << dfaInitStates << "}" << endl;
    cout << "Final States: "; printset(dfaFinalStates); cout << endl;
    cout << "State    ";
    for (unsigned int i = 0; i < alphabet.size(); i++)
    {
        if(alphabet[i] == "E") continue;
        cout << alphabet[i] << "    ";
    }
    cout << endl;
    for (int j = 1; j < dfa.size() + 1; j++)
    {
        cout << j;
        for (unsigned int i = 0; i < alphabet.size(); i++)
        {
            if(alphabet[i] == "E") continue;
            if (dfa[j][alphabet[i]] == 0)
            {
                cout << "    {}";
            }
            else
            {
                cout << "    {" << dfa[j][alphabet[i]] << "}" ;
            }
        }
        cout << endl;
    }
}

//trims brackets from string
void trimBrackets(string &str)
{
    str = str.substr(str.find("{") + 1, (str.find("}") - str.find("{")) - 1);
}

//string to vector, comma delimeted
void stov(string &str, vector<int> &vec)
{
    stringstream ss(str);
    int i;
    while(ss >> i)
    {
        vec.push_back(i);
        ss.ignore(1);
    }
}

//string to alphabet
void stoa(string str, vector<string> &alpha)
{
    stringstream ss(str);
    string letter;
    ss >> letter;
    while(ss >> letter)
    {
        alpha.push_back(letter);
    }
}

//epsilon closure of a set of states
void eclosure(vector<int> estates, set<int> &dfastates) //{1}
{    
    for (auto state : estates) //for each state trans from epsilon
    {
        pair<set<int>::iterator,bool> check;
        check = dfastates.insert(state); //try to insert
        if(check.second) { eclosure(nfa[state]["E"], dfastates); } //new state inserted
    }
}

//prints eclosure to console and calls recursive eclosure function
void eprint(vector<int> estates, set<int> &dfastates)
{
    cout << "E-closure";
    printset(dfastates);
    cout << " = ";
    eclosure(estates, dfastates);
    printset(dfastates);
    cout << " = ";
}

//move to states from letter
set<int> move(set<int> states, string letter)
{
    set<int> moveStates; //viable state transitions
    for (auto state : states) //for each state
    {
        for (auto transition : nfa[state][letter]) //for each letter
        {
            moveStates.insert(transition); //insert each unique state
        }
    }
    return moveStates;
}

int main(int argc, char* argv[]) 
{
    /* Parsing */
    int line = 0;
    string temp;

    while (getline (cin, temp)) //get each line
    {
        switch (line)
        {
            case 0: //initial state
                trimBrackets(temp);
                stov(temp, nfaInitStates);
            break;
            case 1: //final states
                trimBrackets(temp);
                stov(temp, nfaFinalStates);
            break;
            case 2: //unneeded
            break;
            case 3: //alphabet
                stoa(temp, alphabet);
            break;
            default: //state transitions
                int state;
                map<string, vector<int>> stateTrans;
                stringstream ss(temp);

                ss >> state;
                for (unsigned int i = 0; i < alphabet.size(); i++)
                {
                    string transtring;
                    vector<int> transitions;

                    ss >> transtring;
                    trimBrackets(transtring);
                    stov(transtring, transitions);
                    stateTrans[alphabet[i]] = transitions;
                }
                nfa[state] = stateTrans;
            break;
        }
        line++;
    }
  
    /*NFA to DFA algorithm*/
    int dstate = 1;

    /*eclose initial state*/
    set<int> nfaInitSet;
    vector<int> e; //gather every epsilon transition and perform eclosure on new transition
    for (auto s : nfaInitStates) 
    {
        e.insert(e.end(), nfa[s]["E"].begin(), nfa[s]["E"].end());
        nfaInitSet.insert(s);
    }
    eprint(e, nfaInitSet); //print and perform eclosure
    cout << dstate << endl << endl;
    for (auto s : nfaInitSet) //for every state in the start state
    {
        if (count(nfaFinalStates.begin(), nfaFinalStates.end(), s) > 0) { dfaFinalStates.insert(dstate); } //check if it is a final state
    }
    dfaClosed[dstate] = nfaInitSet; //dfaClosed[1] = {1,2,5}
    

    for (auto states : dfaClosed) //for every state added to the dfa
    {
        cout << "Mark " << states.first << endl; //mark state
        for (auto letter : alphabet) //for every letter in the alphabet
        {
            if(letter == "E") continue; //ignore epsilon
            set<int> moveStates = move(states.second, letter); //perform move transition
            if(moveStates.empty()) continue; //ignore empty transitions

            printset(states.second); //print transition
            cout << " --" << letter << "--> ";
            printset(moveStates);
            cout << endl;

            vector<int> e; //gather every epsilon transition and perform eclosure on new transition
            for (auto m : moveStates) { e.insert(e.end(), nfa[m]["E"].begin(), nfa[m]["E"].end()); }

            eprint(e, moveStates); //eclosure

            //if this is a new dfa state
            pair<set<set<int>>::iterator,bool> check;
            check = Dstates.insert(moveStates);
            if(check.second) //new dfa state
            {
                dstate++; //add a new state
                for (auto m : moveStates) //for every state in new transition
                {
                    if (count(nfaFinalStates.begin(), nfaFinalStates.end(), m) > 0) { dfaFinalStates.insert(dstate); } //check if it is a final set
                }
                dfa[states.first][letter] = dstate; //add transition to total dfa
                dfaClosed[dstate] = moveStates; //add to list of dfa states
                cout << dstate << endl;
            }
            else //duplicate state
            {
                for (int i = 1; i < dstate + 1; i++) //find corresponding dfa state of existing set of states
                {
                    if(dfaClosed[i] == moveStates)
                    {
                        dfa[states.first][letter] = i;
                        cout << i << endl;
                        break;
                    }
                }
            }
        }
        cout << endl;
    }
    printResults();
}