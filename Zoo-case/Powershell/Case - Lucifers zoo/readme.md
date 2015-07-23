Mildred’s Magical Creatures moving to Lucifer’s Crowded Zoo
===========================================================

Here’s the deal: Mildred has a lot of magical creatures. In fact, her house is filled with them. Chimaeras in the cellar, sphinxes in the back yard, and mermaids in the bathtub, making it really hard for her to do anything at all.  

So now she’s looking in to sending them all to the zoo. The zoo keeper Lucifer at Crowded Zoo likes the idea of showing magical creatures. They haven’t had any before, mostly because nobody knew the existed. But he’s a bit on the fence, because it would mean so much extra paper work. The zoo keeps track of all its animals in a SharePoint site. Each type of animal has its own site, where Lucifer records information about individuals, how they are doing and how cost effective they are. Bringing in so many new types of creatures would mean that he has to spend time with SharePoint, which he doesn’t like, at all.  

But, Lucifer has an idea! He heard that his new, underpaid caretaker (you) is actually a SharePoint genius, and he thinks: this can be exploited. And think of all the money he can make, once the magical creatures are on display.
This is what you have to work with
--------------------------------
Look through the folder that Mildred sent. There she has recorded when she saved the creatures, what they are called and which individuals each species contains.

* In the folder structure beginning with the folder Magical Creatures is a folder for each creature. Creatures are grouped by their abilities and the folders are arranged hierarchically.
* In each folder that corresponds to an actual creature is a text document (creatureinformation.txt). This document contains which individuals she’s looking to hand over to the zoo, what they are called and when she befriended them.
* The document also contains information on how evil the creatures are (The fact is actually that none of them are evil, they are just scared of force relocation to Lucifer, but you shouldn’t worry about that)
* There is sometimes also a text document in the folder (description.txt) where you can find description of the creature. Somehow this document is filled with #-signs (Mildred has misunderstood tagging). For some unknown reason the text alsom sometimes has this: [1], where the number can be any number.

What Lucifer wants you to do
------------------------------
* Create a site collection called “Magical Creatures”
* For each of the folders, create a sub site to Magical Creatures, following the same hierarchy that the folders have
* On each site corresponding to a creature, create a list called “Creature Information”.
* Parse the document with the creature information, and for each creature found in the document, create a list item in the list. This item should include:
  * How evil they are
  * What they are called
  * When they were befriended
* Add the text from the description.txt to the description of the site. Remove all the #-signs, and the [1]
* Do it all with powershell!
