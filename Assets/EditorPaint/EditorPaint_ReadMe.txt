//---------------
// Copyright 2018 Prized Goat
// Prized Goat is a small indie group of friends, if this file was obtained without purchase,
// please support our efforts by purchasing a copy from the Unity Asset Store.  Thanks
//---------------

Special Thanks to Jack Caron.
Mailbox, Street Sign and Street assets created by Jack Caron.  They are used and distributed as part of EditorPaint with his permission.

Support Forum: https://forum.unity.com/threads/editorpaint-2d-3d-texturing-tools-released.514910/
Documentation: https://connect.unity.com/p/editorpaint-documentation

//---------------
//Tips, Tricks, and Info
//---------------
[How do I open an EditorPaint window?]
	-You can open an EditorPaint window using Window>EditorPaint>...
	-Or a window will automaticaly open when you rightclick>EditorPaint>... on a mesh or texture to edit it.
[Tool tip text]
	-Lots of items in the EditorPaint interface have roll over tool tips.  Be sure to look for them if you are not sure what a button does.
[EditorPaint Hotkeys]
	General
		- Undo : Ctrl + Z
		- Redo : Ctrl + Y
		- Paint brush : B
		- Erase brush : E
		- Fill brush : G
		- Flow brush : F
		- Color picker : C
		- Swap colors : X
		- Decrease brush size : [
		- Increase brush size : ]
		- Snap to axis : Hold Shift before starting to paint.  This will keep the brush on the X or Y screen space axis while painting
	3D window
		- Rotate Camera : Alt + Left mouse button and drag
		- Pan Camera : Alt + Middle mouse button and drag
				  or : Right arrow key, Left arrow key
		- Dolly/Zoom Camera : Alt + Right mouse button and drag
				  or : Up arrow key, Down arrow key
				  or : Mouse Scroll Wheel
		- Camera look : Right mouse button and drag
	2D window
		- Pan : Alt + Middle mouse button and drag  (Can only pan if the image is zoomed in so that its larger than the visible work area)
		- Zoom : Alt + Right mouse button and drag
		    or : Mouse Scroll Wheel
[How do I get support, report a bug, or see what features are planned?]
	-You can check our official forum section on forum.Unity3d.com to see the most recent info, gifs, and videos.
	-email support.prizedgoat@outlook.com if you have bugs, problems, or requests.
[How do I import an object to paint on it?]
	-You can import an object into the EditorPaint window by either dragging it into the 3D Editor Paint window, or on a mesh in the scene: right-clicking > Editor Paint > Send to 3D Editor Paint 
	-The 2D paint window wont let you drag and drop meshes, but it will let you drag and drop Textures.
	-The 3D paint window will let you drag and drop textures as either new objects (drag into the 3d section) or as new layers (drag into the 2d section)
[How do I import a texture and paint on it?]
	-You can edit a texture in the 2d window, 3d window or with Texture Actions in the Project window.
	-Edit textures in the 2d and 3d window by dragging them into it, or by right-clicking > Editor Paint > Edit Texture.
	-You can also find the Texture Actions in this same right click menu in the Project window.
[How do I select imported textures in the paint window so I can paint on them?]
	-In the 2d and 3d paint window, there can be multiple layers which each have a texture.  The active layer is the layer your paint actions will show up in.
	-The active layer has the radio button filled in to the left of the layer name.  The active layer is also a light blue color.
	-To change active layers, click the radial button on the layer.
	-If you have the 2D/3D window open, you will see textures in the 2D window for the active Mesh.  To change the active Mesh in the 2D window, click on the "2D" Focus button for that object in the mesh list.
[How do I import a texture as a new layer on an imported object]
	-You can import a texture into the 3d paint window either as a new object to paint on, or as a new layer on an object.
	-To import the texture as a new layer on a specific object, make sure the object has "Focus" in the paint window by clicking the "2D" button in the object list.
	-Then make sure the layer groups (Albedo, Smoothness, Normal, etc) you want it to import into has one of the layers set to the active layer.  EditorPaint will import the texture as that type of layer.
	-Then drag and drop the texture into the 2d image section of the paint window.
[Whats Dynamic UV?]
	-Dynamic UV is used while painting on 3d objects to allow painting across the object in world space regardless of any UV distortion or UV seems on the object.
	-Projection: Normal : the brush will paint using the triangles Normal as its orientation.    Camera : The brush will paint using the Cameras forward vector as its orientation.
	-Bleed Size: How many pixels DynamicUV should bleed the brush outside of triangles in UV space to prevent UV seams while painting.
[Why doesnt my brush draw clean lines when I paint across 90 degree corners?]
	-If you are painting in 3d across a cube or object with a sharp corner, it may not always paint smoothly across the corner depending on your brush settings.
	-This happens because while painting in 3d, the brush aligns to the surface normal (if your brush is set to Normal projection), since the corner is in a very different direction, it pops to the new surface normal and may not always align with the old surface normal.
	-If you change DynamicUV to use the Camera Projection setting, it will allow you to paint with the least amount of distortion around the corner, but it will introduction distortion in other situations so its best learn both methods and use them where they work best.
[Why does the paint brush sometimes take longer to draw a line and lag behind my cursor?]
	-Editor Paint is making sure your brush draws smoothly and is trying to catch up to your mouse movement.
	-We optimized Editor Paint to work on what are considered relativly slow computers, but it can still slow down once in a while.
	-Things that will cause slower brush painting feedback: really large texture resolutions; really small brush size drawn across large distances; or painting quickly on very complex 3d meshes.
[How can I undo a Texture Action I applied in the Project window of Unity?]
	-The actions dont ask you to confirm a Save or allow Undo because they are non-destructive actions which you can "undo" with addtional Texture Actions.  We made sure to only include non-destruction actions in that list.
[What does the Resync button do?]
	-In the 3d window, when you bring in a 3d mesh we keep a connection to your original imported object.
	-If you change the position, rotation, scale, material settings, etc on the object the values wont show up in Editor Paint until/unless you press the Resync button.
[What is the answer to the Ultimate Question of Life, The Universe, and Everything?]
	-42
[You can create your own Texture Actions to use in the EditorPaint window!]
	-In Assets\EditorPaint\PaintResources\Effects\Actions\    you can duplicate and then modify one of the action shaders to have a unique file name, unique Shader name and custom shader code.
	-Most shader properties are supported and will automaticly show up in the shader settings when the action is used.
	-Once you have written your shader, close Editor Paint and reopen it to see your shader in the Action list in the 2d paint window.
	-Check our forum post soon for a video showing how this is done!


//---------------
//Release notes
//---------------
v 0.9
[New Features]
	-Added support for importing Particle Systems.  (Not all particle system features are supported yet.  Particles can not be painted on in 3d, but their textures can be painted on in 2d while previewing thier simulation.)
	-Added Emissive Light simulation type.  This allows users to bake 'emissive' light onto their objects based on a user selectable input layer type.
	-Added Voronoi simulation type with multiple output types for both 3D and 2D variants.
	-Added circular gradient feature to the gradient texture action.
	-Added Preview Original Material to the Objects interface.  This is useful when you have imported an object but your Editor Paint Project Shader doesnt match and you want to see the original material for reference.
[Improvements]
	-Forced alpha compositing to output greyscale instead of color.  This correctly reflects what will be saved to disc and helps users have less confusion about what channel type they are painting into.
	-Highly improved simulation render times in most cases.
	-Simulations are more stable on lower end computers because of a new perf testing system which runs before a simulation is run.
	-Improved the Objects gui and Global Layers gui size to better share screen space.
	-Simplified the Texture Resolution gui to only show one resolution option instead of the Layer resolution and Composite resolution.
	-10x to 20x DynamicUV perf improvement when painting on very heavy meshes.
	-Adjusted the Global Layers 'New' button and added the Global Layers 'Edit' button to help create clarity for users.
	-Performance improvements across various features.
	-Memory improvements across various features.
	-WorldSpaceGrid visual quality improvements.
[Bug fixes]
	-Fixed _glossmapscale import values bug so we now handle the various forms of texture or no texture values that Unity looks for in the Standard shader.
	-Color picker bug fixs.
	-Bug fixs to the 2d paint window when removing and adding layers.
	-Fixed bug where AO and Thickness simulations would not work on some gpus.
	-Unity 2018 related bug fixs.
	-Fixed gamma issues for some preview textures while running in linear project mode.
	-Various bug fixs across architecture, gui and simulations.

v 0.8.1
[Improvements]
	-Improved asset serialization and project save/load systems so versioning stays in sync.

v 0.8
[New Features]
	-Custom shader support added!  Any *.shader file in Unity that has a 2D texture slot is now supported for painting on.
	-Added Flow Brush type for painting Vector type Flow maps/Combed normal maps.
	-Added Material Animation button to the 3D window for previewing material values that change over time (Caution, may have performance impact on painting depending on your setup).
	-Added support for multiple materials per object.
	-Added Material settings interface GUI for Color, Float, and Vector types to all imported objects.
	-Added Mesh Thickness simulation layer type.
	-Improved Ambient Occlusion simulation logic.
	-Added normal map support to the Directional Gradient simulation layer.
	-Added Distort texture action to 2D Action menu.
	-Added Color Grading texture action to 2D Action menu.
	-User settings improvements.
	-Added new Project settings values for controlling how project creation is handled.
	-Added multiple Brush Texture example files.
	-Added Merge Layer Down feature to the New Layer menu.
[Bug fixes]
	-Misc bug fixs across the GUI code and architecture code.
	-Tiling texture bug fix.
	-Memory allocation cleanup and improvements.
	-Performance improvements in various features.
	-Improved texture import handling and fail case reporting.
	-Fixed project save default location to be relevant to previous save locations and names.

v 0.5.1
[New Features]
	-Added support for BMP, TIF, GIF formats
	-Improved File Save UX so that it better detects the save location and file name/extension
[Bug fixes]
	-Fixed unsupported texture format imports so that it prevents the import and logs information for the user

v 0.5
[New Features]
	-Support for Unity3D 5.5 to Unity 2017 (tested up to 2017.3 as of the EditorPaint 0.5v release)
	-2d paint window
	-3d paint window
	-Gamma and Linear engine support
	-Uncompressed texture loading
	-Project saving and loading
	-Undo / Redo support
	-EditorPaint copy/paste
	-Color swatches
	-DynamicUV support with two projection modes
	-Texture actions
	-Support for user created custom texture actions
	-Simulation layers (Ambient Occlusion, World space grid, World space noise, Directional gradient. Position gradient)
	-Custom brush textures
	-Brush blend modes
	-Layer blend modes
	-Quick texture actions in the project right click menu
	-Display object UVs or Grid
	-Custom color picker for improved accuracy
	-Layer resolution and Canvas resolution
	-Mesh, SkeletalMesh, Sprite, Texture importing support
[Bug fixes]
	-(initial release)


FreeImage info:
We use FreeImage in EditorPaint.  It can be used for consumer or commercial work.  If you are interested in their license, please see the below info.
"The contents of this file are subject to the FreeImage Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://freeimage.sourceforge.net/freeimage-license.txt""
