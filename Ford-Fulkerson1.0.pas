// Ford-Fulkerson Algorithm

// Coded by Denis Tamkovich
// Review by @jaselnik

Const
  MAX_N = 10;

Type 
  TMatrAdj = array[1..MAX_N, 1..MAX_N] of integer;
  TParent = array[1..MAX_N]of integer;
  
// Read Graph from file
Procedure Input(Var mas:TMatrAdj; Var n:integer; filename:string);
Var
  f:textfile;
  i,j:integer;
Begin
  assignfile(f,filename); reset(f);
  readln(f,n);
  For i:=1 to n do
    For j:=1 to n do
      read(f,mas[i,j]);
  closefile(f);
End;

// Print the Graph
Procedure Output(mas:TMatrAdj; n:integer);
Var
  i,j:integer;
begin
  For i:=1 to N do
  begin
    For j:=1 to N do
    begin
      write(mas[i,j]:2);
    end;
    writeln;
  end;
end;

// BFS - Breadth-First Search
Function BFS(graph:TMatrAdj;n,source,sink:integer;Var parent:TParent):boolean;
Var
  i,j,q_index,q_len,s:integer;
  visited:array[1..MAX_N]of boolean;
  queue:array[1..MAX_N]of integer;
Begin
  For i:=1 to n do
  begin
    visited[i]:=False;
    queue[i]:=0;
  end;
  
  // Mark the source node as visited and add it into the queue 
  q_index:=1;
  q_len:=1;
  queue[q_index]:=source;
  visited[source]:=True;
  s:=source;
  While q_index <= q_len do
  begin
    For i:=1 to n do
      if not visited[i] and (graph[s,i]>0) then
      begin
        inc(q_len);
        queue[q_len]:=i;
        visited[i]:=True;
        parent[i]:=s;
      end;
    inc(q_index);
    s:=queue[q_index];
  end;
  
  BFS:=visited[sink];
End;

// Algorithm Ford-Falkeson
Function FordFulkerson(graph: TMatrAdj; n,source,sink:integer):integer;
Var
  i,j,max_flow,path_flow,s,u,v:integer;
  parent: TParent; // there we are saving the parent-node 
Begin
  For i:=1 to n do
    parent[i]:=0;
  
  max_flow:=0; // initially our maximum flow is = 0
  // Check if there are any available ways      
  While BFS(graph,n,source,sink,parent) do 
  begin
    path_flow:=graph[parent[sink],sink];
    s:=parent[sink];
    // There we looking for minimum flow to sink (path flow)
    While s <> source do 
    begin
      path_flow:=min(path_flow,graph[parent[s],s]);
      s:=parent[s];
    end;
    // increasing our max flow to the path flow  
    inc(max_flow,path_flow);
    
    v:=sink;
    // decrease the current path values 
    // and increase the opposite of this path
    // According to a Lecture graph[u,v]=-graph[v,u]
    // we have:
    // graph[u,v]-=path_flow
    // graph[v,u]+=path_flow
    While v <> source do
    begin
      u:=parent[v];
      dec(graph[u,v],path_flow);
      inc(graph[v,u],path_flow);
      v:=parent[v];
    end;
  end;
  
  // return our maximum flow
  FordFulkerson:=max_flow;
End;
  
Var
  graph: TMatrAdj; // adjacency matrix
  n,source,sink:integer;
Begin
  Input(graph,n,'input.txt');
  Output(graph,n);
  source:=1;
  sink:=n;
  write('The maximum possible flow is ',FordFulkerson(graph,n,source,sink));
End.
