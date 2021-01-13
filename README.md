# SwiftUsingFlickrDemoProject
A Swift 5 Demo project using Flickr

A simple demo project that uses a "shared" Collectionview in different ViewControllers

The idea is to have one CollectionView Controller only and use the its view on other controllers when needed

It uses a TabViewController and also saves the Favorites using *UserDefaults* 

It also allows people to share the images using * UIActivityViewController* 

Please keep in mind that it took me a few hours only to put it to togheter and, as always, there is a lot of 
room for improvement.

Anyways, hope it can help...

Setup
Go to https://identity.flickr.com and either create a new Flickr account, or sign in with your existing account.
Once signed in successfully, go to Flickr API Explorer. 

https://www.flickr.com/services/api/explore/flickr.photos.search

Find and click Call Method… at the bottom of the page.
This will generate a URL link at the very bottom of the page that looks like:

URL: https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=5955dc63b8f9660f8a15b10d63bb2641&format=rest

Copy the API key from the URL. You can find this by looking for the number between &api_key= and the next & you see.
Note: The API key changes every day or so, so you’ll occasionally have to regenerate a new key.

On the code, find *FlickerService.swift* and add the api_key there

    class FlickrConstants {
    
    /// TODO: add your api_key
    static let api_key = "XXXXXX"
    
    ....
    }

Have a wonderful day...
