import System.IO
import Data.Char
import Data.List.Split
import Data.Map (fromListWith, toList)
import Data.Function (on)
import Data.List (sortBy)

-- Main function
-- use print and not putStrLn as it is sooooooo much easier
-- prints can be commented to in to show the workings of the stages
main = do
		-- Load file to process and extract text
		-- WarAndPeace by Leo Tolstoy as an example of a big file (730000 words)
		--contentsOfFileToProcess <- readFile "WarAndPeace.txt"
		contentsOfFileToProcess <- readFile "test.txt"
		putStr "\nOriginal Text Loaded . . ."
		--print contentsOfFileToProcess
		
		-- split the file into a list of words 
		let listOfFileWords = words contentsOfFileToProcess
		putStr "\nOriginal Text converted to list of words . . ."
		--print listOfFileWords
		
		-- remove the punctuation and set the contents to be lower case
		let afterRemovingPunc = map removePuncLowerCase listOfFileWords
		putStr "\nList of Words set to lower case and punctuation removed . . ."
		--print afterRemovingPunc
			
		-- Load the transition words
		contentsOfTransitionFile <- readFile "TransitionWords.txt"
		putStr "\nTransition words loaded . . ."
		--print contentsOfTransitionFile
		
		-- Split the transition words into a list
		let transitionWords = splitOn "," contentsOfTransitionFile
		putStr "\nTransition words split into a list . . ."
		--print transitionWords
		
		-- Compare the text file to the transition words and remove transition words
		let comparisonResult = compareAndRemove afterRemovingPunc transitionWords
		putStr "\nComparison and removoval transition words from text file . . ."
		--print comparisonResult
		
		-- Count occurences of the words and add to a new list with [word, count] structure
		let occurencesList = countOccurences comparisonResult
		putStr "\nCounting word occurences . . ."
		--print occurencesList
		
		-- Sort the list
		let sortedOccurenceList = sortBy (compare `on` snd) occurencesList
		putStr "\nSorting the occurences . . ."
		--print sortedOccurenceList
		
		-- Put the occurences into descending order
		let sortedOccurenceListReversed = reverse sortedOccurenceList
		putStr "\nReversing the sorted list . . ."
		--print sortedOccurenceListReversed
		
		-- Take the top 10 words into a new list
		let topTenWords = take 10 sortedOccurenceListReversed
		putStr "\nPinting Top 10 word occurences . . .\n"
		mapM_ print topTenWords
		
		return ()
		

-- Process text functions
-- Function: removePuncLowerCase
-- Remove punctuation from the list by deleting it and set letters to lower case
removePuncLowerCase :: String -> String
removePuncLowerCase xs = [toLower x | x<-xs, not (x `elem` ",.?!-:;\"\'")]

-- Function: compareAndRemove
-- Compare the lists and remove the transition words
compareAndRemove :: [String] -> [String] -> [String]
compareAndRemove (x:xs) (ys)
	| x `elem` ys = filter (\w -> w `notElem` ys) xs
	| otherwise = compareAndRemove xs ys
	
-- Function: countOccurences
-- Count the occurences of the words and return a list of tuples
countOccurences :: (Ord a) => [a] -> [(a, Int)]
countOccurences xs = toList (fromListWith (+) [(x, 1) | x <- xs])