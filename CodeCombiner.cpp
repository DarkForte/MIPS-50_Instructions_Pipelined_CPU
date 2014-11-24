#include<iostream>
#include<fstream>
using namespace std;
ifstream fin_a("code.txt");
ifstream fin_b("code_handler.txt");

ofstream fout("code_combined.txt");

int main()
{
	int i=0x3000;
	string s;
	fout<<"MEMORY_INITIALIZATION_RADIX=16;"<<endl;
	fout<<"MEMORY_INITIALIZATION_VECTOR="<<endl;
	while(fin_a>>s)
	{
		fout<<s<<endl;
		i+=4;
	}
	while(i!=0x4180)
	{
		fout<<"00000000"<<endl;
		i+=4;
	}
	while(fin_b>>s)
	{
		fout<<s<<endl;
		i+=4;
	}
	fout<<";"<<endl;
	return 0;
}

