(**

  This module implements the IOISOTAServicePath interface for storing a list of service interfaces
  with the depth of the associated tree so that the shortest path can be found.

  @Author  David Hoyle
  @Version 1.0
  @Date    11 Dec 2016

**)
Unit OTAIntfSearch.OTAServicePaths;

Interface

Uses
  OTAIntfSearch.Interfaces,
  Generics.Collections,
  Generics.Defaults,
  VirtualTrees;

Type
  (** A concrete implementation of the IOISOTAServicePath interface, **)
  TOISOTAServicePaths = Class(TInterfacedObject, IOISOTAServicePaths)
  Strict Private
    Type
      (** A record to describe the elements contained in the collection. **)
      TServicePath = Record
        FServicePath : PVirtualNode;
        FPathLength  : Integer;
      End;
    (** An IComparer class to allow for custom sorting of the TList<T> collection. **)
    TServicePathComparer = Class(TComparer<TServicePath>)
    Strict Private
    Strict Protected
    Public
      Function Compare(Const Left, Right : TServicePath) : Integer; Override;
    End;
  Strict Private
    FServicePaths : TList<TServicePath>;
    FOTACodeTree  : TVirtualStringTree;
    FComparer     : TServicePathComparer;
  Strict Protected
    Procedure AddServicePath(TreeNode: Pointer);
    Function  ShortestServicePath: Pointer;
    Procedure SortServicePaths;
  Public
    Constructor Create(vstOTACodeTree : TVirtualStringTree);
    Destructor Destroy; Override;
  End;

Implementation

Uses
  SysUtils;

{ TOISOTAServicePaths.TServicePathComparer }

(**

  This is a ICompare.Comparer method to sort the TList<> collection.

  @precon  None.
  @postcon Sorts the TList<> by the path length.

  @param   Left  as a TServicePath as a constant
  @param   Right as a TServicePath as a constant
  @return  an Integer

**)
Function TOISOTAServicePaths.TServicePathComparer.Compare(Const Left, Right: TServicePath): Integer;

Begin
  Result := Left.FPathLength - Right.FPathLength;
End;

{ TOISOTAServicePaths }

(**

  This mehod adds a service path pointer and path length to the collection.

  @precon  TreeNode must be a valid PVirtualNode pointer.
  @postcon Adds a service path and length to the end of the collection.

  @param   TreeNode as a Pointer

**)
Procedure TOISOTAServicePaths.AddServicePath(TreeNode: Pointer);

Var
  P : PVirtualNode;
  recServicePath: TServicePath;

Begin
  recServicePath.FServicePath := TreeNode;
  recServicePath.FPathLength := 0;
  P := TreeNode;
  While P <> Nil Do
    Begin
      Inc(recServicePath.FPathLength);
      P := P.Parent;
    End;
  FServicePaths.Add(recServicePath);
End;

(**

  A constructor for the TOISOTAServicePaths class.

  @precon  vstOTACodeTree must be a valid instance.
  @postcon Creates an empty collection.

  @param   vstOTACodeTree as a TVirtualStringTree

**)
Constructor TOISOTAServicePaths.Create(vstOTACodeTree: TVirtualStringTree);

Begin
  FComparer := TServicePathComparer.Create;
  FServicePaths := TList<TServicePath>.Create(FComparer);
  FOTACodeTree := vstOTACodeTree;
End;

(**

  A destructor for the TOISOTAServicePaths class.

  @precon  None.
  @postcon Frees the collection.

**)
Destructor TOISOTAServicePaths.Destroy;

Begin
  FServicePaths.Free;
  Inherited Destroy;
End;

(**

  This method returns the service path PVitrualTree pointer for the shortest path if there are
  service paths in the collection.

  @precon  None.
  @postcon The shortest service path is returned.

  @return  a Pointer

**)
Function TOISOTAServicePaths.ShortestServicePath: Pointer;

Begin
  Result := Nil;
  If FServicePaths.Count > 0 Then
    Result := FServicePaths[0].FServicePath;
End;

(**

  This method sorts the collection.

  @precon  None.
  @postcon The collection is sorted.

**)
Procedure TOISOTAServicePaths.SortServicePaths;

Begin
  FServicePaths.Sort;
End;

End.
