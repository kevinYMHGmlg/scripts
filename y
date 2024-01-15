--[[
	Windy Island = Dream 0
	Ten Mou = Dream 2
	Graveyard Sea = Dream 3
	Ocean Lab = Dream 4
	Vulcanic Heights = Dream 5
]]

local IsPrivate=false

-- services
local ReplicatedStorage=game:GetService'ReplicatedStorage'
local InsertService=game:GetService'InsertService'
local Debris=game:GetService'Debris'
local UserInputService=game:GetService'UserInputService'


-- declarations
local CurrentDream=ReplicatedStorage:WaitForChild'Data':WaitForChild'Dream'
local Main=InsertService:LoadLocalAsset'rbxassetid://14904107029'
Main.Parent=game.CoreGui
Main.Enabled=true
local Interactables=Main.Interactables
local Entities=Main.Entities
local EHolder=Entities.Holder
local IHolder=Interactables.Holder
EHolder.CanvasSize=UDim2.new(0,0,10,0)
IHolder.CanvasSize=EHolder.CanvasSize
local Players=game.Players
local LocalPlayer=Players.LocalPlayer
local CurrentCamera=workspace.CurrentCamera
local Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- functions
local function Create(Type)
	if type(Type)~='string'then 
		error('Argument of Create must be a string',2)
	end 
	return function(dat)
		dat=dat or{}
		local obj=Instance.new(Type)
		local parent,ctor 
		for k,v in next,dat do 
			if type(k)=='string'then 
				if k=='Parent'then 
					parent=v 
					continue 
				end 
				obj[k]=v 
			elseif type(k)=='number'then 
				if type(v)~='userdata'then 
					error('Bad entry in Create body: Numeric keys must be paired with children, got a: '..type(v),2)
				end 
				v.Parent=obj 
			elseif type(k)=='table'and k.__eventname then 
				if type(v)~='function'then 
					error('Bad entry in Create body: Key \'[Create.E\''..k.__eventname..'\']\' must have a function value, got: '..tostring(v),2)
				end 
				obj[k.__eventname]:Connect(v)
			elseif k==Create then 
				if type(v)~='function'then 
					error('Bad entry in Create body: Key \'[Create]\' should be paired with a constructor function, got: '..tostring(v),2)
				elseif ctor then 
					error('Bad entry in Create body: Only one constructor function is allowed',2)
				end 
				ctor=v 
			else 
				error('Bad entry ('..tostring(k)..' => '..tostring(v)..') in Create body',2)
			end 
		end 
		if ctor then 
			ctor(obj)
		end 
		if parent then 
			obj.Parent=parent 
		end 
		return obj 
	end
end
local function SetCharacter(Character)
	local Head=Character:WaitForChild'Head'
	if Head then
		Head.ChildAdded:Connect(function(int)
			if int:IsA'AlignPosition'then
				Debris:AddItem(int,0)
			end
		end)
	end
	local Humanoid=Character:WaitForChild'Humanoid'
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
end
local function GetNet()
	if not Character then return end
	local Net=Character:FindFirstChild'ShinyNet'
	if not Net then return end
	return Net:FindFirstChild'Handle'
end
local Touch=firetouchinterest
--[[
local function Find(Model)
	if table.find(Model.Name,{'Hellos','Hells'})then
	local Humanoid=Model:FindFirstChildWhichIsA'Humanoid'
	print(Model,Humanoid)
	if not Humanoid then 
		for _,x in next,Model:GetChildren()do
			Humanoid=Find(x)
			if Humanoid then break end
		end
		return
	end
	if Humanoid.Name=='Inaninoid'or not Humanoid.RootPart then return end
	return Model.PrimaryPart,Humanoid
end
]]
local function RenderNewButton(Name:string,Parent)
	local NewButton=EHolder.Template:Clone()
	NewButton.Visible=true
	NewButton.Name=Name
	NewButton.Text=Name
	NewButton.Parent=Parent
	return NewButton
end
local function LongWaitForChild(...)
	local A={...}
	local B=A[1]
	task.spawn(function()
		for i=2,#A do 
			B=B:FindFirstChild(A[i])or B:WaitForChild(A[i],120)
		end 
		return B
	end)
end

-- main program
SetCharacter(Character)
LocalPlayer.PlayerGui.Sleep.Frame.Visible=false
LocalPlayer.CharacterAdded:Connect(function(Char)
	Character=Char
	SetCharacter(Character)
end)

local Mappy=workspace:FindFirstChild'Mappy'or workspace:FindFirstChild'Map'
local Entity_Event=Instance.new'BindableEvent'
local Interactable_Event=Instance.new'BindableEvent'
local ClickDetectors={}
Interactable_Event.Event:Connect(function(Cd:ClickDetector)
	task.wait(.2)
	if table.find(ClickDetectors,Cd)then return end
	table.insert(ClickDetectors,Cd)
	local Cd_Parent=Cd.Parent
	local Button=RenderNewButton(Cd_Parent.Name,IHolder)
	Cd_Parent:GetPropertyChangedSignal'Parent':Connect(function()
		Debris:AddItem(Button,0)
	end)
	Cd_Parent.Destroying:Once(function()
		Debris:AddItem(Button,0)
	end)
	Button.MouseButton1Click:Connect(function()
		fireclickdetector(Cd)
	end)
	Button.MouseButton2Click:Connect(function()
		if typeof(Cd_Parent)~='Instance'then return end
		if CurrentCamera.CameraSubject==Cd_Parent then
			CurrentCamera.CameraType=Enum.CameraType.Custom
			CurrentCamera.CameraSubject=Character:FindFirstChild'Humanoid'
			return
		end
		CurrentCamera.CameraType=Enum.CameraType.Follow
		CurrentCamera.CameraSubject=Cd_Parent
	end)
	Button.MouseButton2Up:Connect(function()
		if Cd_Parent.Parent==nil then
			Debris:AddItem(Button,0)
			return
		end
	end)
end)
local CI=UserInputService.InputBegan:Connect(function(Input,Processed)
	if Processed then return end
	if Input.UserInputType~=Enum.UserInputType.Keyboard then return end
	if Input.KeyCode==Enum.KeyCode.L then 
		Main.Enabled=not Main.Enabled
	elseif Input.KeyCode==Enum.KeyCode.P then
        workspace.MainSleep.SleepEvent:FireServer()
	end
end)
Entity_Event.Event:Connect(function(Model:Model)
	if not Model then return end
	if table.find({'Hellos','Hells','Will You?'},Model.Name)then
		for _,Child in next,Model:GetChildren()do
			local Humanoid=Child:FindFirstChildWhichIsA'Humanoid'
			local Torso=Child:WaitForChild('Torso',12)
			if not Humanoid or not Torso then return end
			if not Humanoid.RootPart then return end
			local Button=RenderNewButton(Child.Name,EHolder)
			Child:GetPropertyChangedSignal'Parent':Once(function()
				Debris:AddItem(Button,0)
			end)
			Child.Destroying:Once(function()
				Debris:AddItem(Button,0)
			end)
			Button.MouseButton1Click:Connect(function()
				local ShinyNet=GetNet()
				if not ShinyNet then return end
				Touch(ShinyNet,Torso,0)
				Touch(ShinyNet,Torso,1)
			end)
			Button.MouseButton2Click:Connect(function()
				if CurrentCamera.CameraSubject==Torso then
					CurrentCamera.CameraType=Enum.CameraType.Custom
					CurrentCamera.CameraSubject=Character:FindFirstChild'Humanoid'
					return
				end
				CurrentCamera.CameraType=Enum.CameraType.Follow
				CurrentCamera.CameraSubject=Torso
			end)
			Button.MouseButton2Up:Connect(function()
				if Child.Parent then return end
				Debris:AddItem(Button,0)
			end)
		end
		return
	end
	task.wait(.2)
	local Humanoid=Model:FindFirstChildWhichIsA'Humanoid'
	local Torso
	if Model.Name=='Old Thunder'then
		Torso=Model:WaitForChild('Engine',3)
	elseif Model.Name=='Lifespan of Robloxian Detected Activity'then
		Torso=Model:WaitForChild('Head',3)
	else
		Torso=Model:WaitForChild('Torso',3)or Model:WaitForChild('Engine',3)
	end
	if not Humanoid or not Torso then return end
	if not Humanoid.RootPart then return end
	local Button=RenderNewButton(Model.Name,EHolder)
	Model:GetPropertyChangedSignal'Parent':Once(function()
		Debris:AddItem(Button,0)
	end)
	Model.Destroying:Once(function()
		Debris:AddItem(Button,0)
	end)
	Button.MouseButton1Click:Connect(function()
		local ShinyNet=GetNet()
		if not ShinyNet then return end
		Touch(ShinyNet,Torso,0)
		Touch(ShinyNet,Torso,1)
	end)
	Button.MouseButton2Click:Connect(function()
		if CurrentCamera.CameraSubject==Torso then
			CurrentCamera.CameraType=Enum.CameraType.Custom
			CurrentCamera.CameraSubject=Character:FindFirstChild'Humanoid'
			return
		end
		CurrentCamera.CameraType=Enum.CameraType.Follow
		CurrentCamera.CameraSubject=Torso
	end)
	Button.MouseButton2Up:Connect(function()
		if Model.Parent then return end
		Debris:AddItem(Button,0)
	end)
end)
local function DetectFrom(Folder)
	if not Folder then return end
	for _,x in next,Folder:GetChildren()do
		if not x:IsA'Model'then continue end
		Entity_Event:Fire(x)
	end
	local CI
	CI=Folder.ChildAdded:Connect(function(PVInstance)
		if not Main then CI:Disconnect()return end
		if not PVInstance:IsA'Model'then return end
		--warn(`FOUND {PVInstance.Name}`)
		Entity_Event:Fire(PVInstance)
	end)
end
--[[do
	DetectFrom(Mappy:FindFirstChild'Entities')
	DetectFrom(Mappy:FindFirstChild'EntitySave')
	for _,x in next,workspace:GetDescendants()do
		if not x:IsA'ClickDetector'or table.find(ClickDetectors,x)then continue end
		table.insert(ClickDetectors,x)
		Interactable_Event:Fire(x)
	end
end]]
local function Check()
	if CurrentDream.Value==0 then
		local Mappy=workspace:WaitForChild'Map'
		for _,x in next,Mappy:GetDescendants()do
			if not x:IsA'ClickDetector'then continue end
			x.MaxActivationDistance=math.huge
			Interactable_Event:Fire(x)
		end
		Mappy.DescendantAdded:Connect(function(PV)
			if not PV:IsA'ClickDetector'then return end
			PV.MaxActivationDistance=math.huge
			Interactable_Event:Fire(PV)
		end)
		local Entities=Mappy:WaitForChild'Entities'
		DetectFrom(Entities)
		--local Map=Mappy:WaitForChild'Map'
	elseif table.find({2,3,4,5},CurrentDream.Value)then
		local Mappy=workspace:WaitForChild'Mappy'
		for _,x in next,Mappy:GetDescendants()do
			if not x:IsA'ClickDetector'then continue end
			x.MaxActivationDistance=math.huge
			Interactable_Event:Fire(x)
		end
		Mappy.DescendantAdded:Connect(function(PV)
			if not PV:IsA'ClickDetector'then 
				--[[if PV:IsA'Humanoid'then
					Find(PV.Parent)
				end]]
				return 
			end
			PV.MaxActivationDistance=math.huge
			Interactable_Event:Fire(PV)
		end)
		local Entities=Mappy:WaitForChild'Entities'
		local EntitySave=Mappy:WaitForChild'EntitySave'
		if EntitySave.EntityCount.Value>0 then
			DetectFrom(EntitySave)
		end
		DetectFrom(Entities)
		--
		-- Exclusive
		if CurrentDream.Value==5 then
			local Map=Mappy:WaitForChild'Map'
			local Traps=Map:WaitForChild'Traps'
			for _,x in next,Traps:GetChildren()do
				if x.Name~='Trap'then continue end
				task.spawn(function()
					Entity_Event:Fire(x:WaitForChild('Arrow Spitter',5))
				end)
			end
			Traps.ChildAdded:Connect(function(PV)
				if PV.Name~='Trap'then return end
				Entity_Event:Fire(PV:WaitForChild('Arrow Spitter',5))
			end)
		elseif CurrentDream.Value==2 then
			local Map=Mappy:WaitForChild'Map'
			task.spawn(function()
				local OldNicky=Map:WaitForChild('Old Nicky',12)
				if not OldNicky then return end
				task.wait(.2)
				Entity_Event:Fire(OldNicky)
			end)
			local Sword=Map:WaitForChild('Sword Fighting Arena',12)
			if not Sword then return end
			local Lifespan=Sword:WaitForChild('Lifespan of Robloxian Detected Activity',12)
			if not Lifespan then return end
			Entity_Event:Fire(Lifespan)
		end
	else
		local Mappy=workspace:WaitForChild'Mappy'
		for _,x in next,Mappy:GetDescendants()do
			if not x:IsA'ClickDetector'then continue end
			x.MaxActivationDistance=math.huge
			Interactable_Event:Fire(x)
		end
		Mappy.DescendantAdded:Connect(function(PV)
			if not PV:IsA'ClickDetector'then 
				return 
			end
			PV.MaxActivationDistance=math.huge
			Interactable_Event:Fire(PV)
		end)
		local Entities=Mappy:WaitForChild'Entities'
		local EntitySave=Mappy:WaitForChild'EntitySave'
		if EntitySave.EntityCount.Value>0 then
			DetectFrom(EntitySave)
		end
		DetectFrom(Entities)
		--local Map=Mappy:WaitForChild'Map'
	end
end
task.spawn(Check)
local CII=CurrentDream:GetPropertyChangedSignal'Value':Connect(Check)
--[[
workspace.ChildAdded:Connect(function(I)
	if I.Name=='Mappy'or I.Name=='Map'then
		Mappy=I
		task.wait(15)
		task.spawn(function()
			local Ig=Mappy:WaitForChild('Entities',10)
			if Ig then
				DetectFrom(Ig)
			end
		end)
        task.spawn(function()
            local Ig=Mappy:WaitForChild('EntitySave',10)
            if Ig then
                DetectFrom(Ig)
            end
        end)
		for _,x in next,EHolder:GetChildren()do
			if x:IsA'UIListLayout'then continue end
			firesignal(x.MouseButton2Up)
		end
		for _,x in next,IHolder:GetChildren()do
			if x:IsA'UIListLayout'then continue end
			firesignal(x.MouseButton2Up)
		end
		for _,x in next,workspace:GetDescendants()do
			if not x:IsA'ClickDetector'or table.find(ClickDetectors,x)then continue end
			
		end
	end
end)
]]
local a=LocalPlayer.PlayerGui.DreamCounter.TextLabel
local ci=a:GetPropertyChangedSignal'Visible':Connect(function()
    if not a.Visible then
        a.Visible=true
    end
end)
if IsPrivate then
	local lake=workspace.Map.Map.RNGBreak.Lakes
	local core=Create'ScreenGui'{
	    Name='hai',
	    Parent=game.CoreGui
	}
	local frame=Create'Frame'{
	    AnchorPoint=Vector2.new(.5,.5),
	    BackgroundTransparency=1,
	    Position=UDim2.new(.5,0,.1,0),
	    Size=UDim2.new(.25,0,.1,0),
	    Parent=core
	}
	local A=Create'TextLabel'{
	    Size=UDim2.new(.333,0,1,0),
	    TextColor3=Color3.new(0,0,0),
	    TextScaled=true,
	    Name='P1',
	    Parent=frame
	}
	local B=Create'TextLabel'{
	    Size=UDim2.new(.333,0,1,0),
	    Position=UDim2.new(.333,0,0,0),
	    TextColor3=Color3.new(0,0,0),
	    TextScaled=true,
	    Name='P2',
	    Parent=frame
	}
	local C=Create'TextLabel'{
	    Size=UDim2.new(.333,0,1,0),
	    Position=UDim2.new(.667,0,0,0),
	    TextColor3=Color3.new(0,0,0),
	    TextScaled=true,
	    Name='P3',
	    Parent=frame
	}
	for i=1,3 do
	    local obj,arg=lake['P'..i],frame['P'..i]
	    local ccolor=obj.CColor
	    arg.Text=ccolor.Value
	    arg.BackgroundColor3=obj.Color
	    ccolor:GetPropertyChangedSignal'Value':Connect(function()
	        arg.Text=ccolor.Value
	    end)
	    obj:GetPropertyChangedSignal'Color':Connect(function()
	        arg.BackgroundColor3=obj.Color
	    end)
	end
end
Main.Destroying:Once(function()
	CI:Disconnect(CII:Disconnect())
end)	
