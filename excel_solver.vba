Sub WordSearchSolver()
    Dim grid As Range
    Dim wordsList As Range
    Dim word As String
    Dim r As Integer, c As Integer
    Dim gridArray() As String
    Dim found As Boolean
    Dim wordLocations As String
    Dim cell As Range
    Dim diagArray() As String
    Dim length As Integer
    Dim i As Integer

    ' Define the grid and words sheet
    Set grid = Sheets("grid").Range("A1:T20") ' 20x20 grid
    Set wordsList = Sheets("words").Range("A1:A" & Sheets("words").Cells(Rows.Count, 1).End(xlUp).Row)

    ' Reset all cell highlights (clear background colors)
    grid.Interior.ColorIndex = xlNone

    ' Initialize an array for the grid
    ReDim gridArray(1 To 20, 1 To 20)

    ' Load grid into array
    For r = 1 To 20
        For c = 1 To 20
            gridArray(r, c) = grid.Cells(r, c).Value
        Next c
    Next r

    ' Loop through each word in the words list
    For Each cell In wordsList
        word = cell.Value
        wordLocations = ""
        found = False
        length = Len(word)

        ' Search each row
        For r = 1 To 20
            If InStr(Join(Application.Index(gridArray, r), ""), word) > 0 Then
                wordLocations = wordLocations & "Row " & r & ", "
                found = True
                ' Highlight the word
                For i = 1 To length
                    grid.Cells(r, InStr(Join(Application.Index(gridArray, r), ""), word) + i - 1).Interior.Color = vbYellow
                Next i
            End If
        Next r

        ' Search each column
        For c = 1 To 20
            Dim colArray() As String
            ReDim colArray(1 To 20)

            For r = 1 To 20
                colArray(r) = gridArray(r, c)
            Next r

            If InStr(Join(colArray, ""), word) > 0 Then
                wordLocations = wordLocations & "Column " & c & ", "
                found = True
                ' Highlight the word
                For i = 1 To length
                    grid.Cells(InStr(Join(colArray, ""), word) + i - 1, c).Interior.Color = vbYellow
                Next i
            End If
        Next c

        ' Search top-left to bottom-right diagonals
        For r = 1 To 20
            For c = 1 To 20
                If r + length - 1 <= 20 And c + length - 1 <= 20 Then
                    ReDim diagArray(1 To length)
                    For d = 1 To length
                        diagArray(d) = gridArray(r + d - 1, c + d - 1)
                    Next d
                    If Join(diagArray, "") = word Then
                        wordLocations = wordLocations & "Top-left to bottom-right from (" & r & "," & c & "), "
                        found = True
                        ' Highlight the word
                        For d = 1 To length
                            grid.Cells(r + d - 1, c + d - 1).Interior.Color = vbYellow
                        Next d
                    End If
                End If
            Next c
        Next r

        ' Search top-right to bottom-left diagonals
        For r = 1 To 20
            For c = 20 To 1 Step -1
                If r + length - 1 <= 20 And c - length + 1 >= 1 Then
                    ReDim diagArray(1 To length)
                    For d = 1 To length
                        diagArray(d) = gridArray(r + d - 1, c - d + 1)
                    Next d
                    If Join(diagArray, "") = word Then
                        wordLocations = wordLocations & "Top-right to bottom-left from (" & r & "," & c & "), "
                        found = True
                        ' Highlight the word
                        For d = 1 To length
                            grid.Cells(r + d - 1, c - d + 1).Interior.Color = vbYellow
                        Next d
                    End If
                End If
            Next c
        Next r

        ' Output the result for each word
        If found Then
            cell.Offset(0, 1).Value = "Found at " & wordLocations
        Else
            cell.Offset(0, 1).Value = "Not found"
        End If
    Next cell
End Sub

