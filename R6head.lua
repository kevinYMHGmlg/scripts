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
local Character=game.Players.LocalPlayer.Character
local HumanoidRootPart=Character.HumanoidRootPart
local Humanoid=Character.Humanoid
if Humanoid.RigType~=Enum.HumanoidRigType.R6 then
    warn'r15'
    return
end
local OldGravity=workspace.Gravity
Humanoid.WalkSpeed=7
Humanoid.JumpPower=4
Humanoid.UseJumpPower=true
Humanoid.CameraOffset+=Vector3.new(0,3,0)
Humanoid.Died:Connect(function()
    workspace.Gravity=OldGravity
end)
workspace.Gravity=10
for _,x in next,Character:GetChildren()do
    if x:IsA'Accessory'then
        local Handle=x:FindFirstChild'Handle'
        if Handle then
            for _,y in next,Handle:GetConnectedParts()do
                if y.Name=='Head'or y.Name=='Handle'then
					y.CanCollide=false
                    continue
                end
                Handle.Transparency=1
                break
            end
        end
        continue
    end
    if not x:IsA'BasePart'or x.Name=='Head'then continue end
    x.Transparency=1
    if x.Name=='Torso'then
        x.Neck.C0=CFrame.new(0,-1,0,-1,0,0,0,0,1,0,1,0)
		for _,y in next,{'Right','Left'}do
			x[`{y} Shoulder`].C0-=Vector3.new(0,3.7,0)
		end
    end
end
for _,x in next,{'Left Leg','Right Leg'}do
    local Leg=Character:FindFirstChild(x)
    Leg:Destroy()
end
Character.Animate.Enabled=false
for _,x in next,Humanoid.Animator:GetPlayingAnimationTracks()do
    x:Stop()
end
local FakeRoot=HumanoidRootPart:Clone()
for _,x in next,FakeRoot:GetChildren()do
    if x:IsA'Sound'then
        x:Destroy()
    end
end
FakeRoot.Parent=Character
HumanoidRootPart.Transparency=.5
HumanoidRootPart.CanCollide=false
HumanoidRootPart.RootJoint.Part0=nil
HumanoidRootPart.Parent=FakeRoot
local A0,A1=HumanoidRootPart.RootAttachment,FakeRoot.RootAttachment
A0.CFrame+=Vector3.new(0,3.65,0)
Create'AlignPosition'{
    MaxAxesForce=Vector3.one*math.huge,
    MaxVelocity=math.huge,
    Responsiveness=200,
    Attachment0=A0,
    Attachment1=A1,
    Parent=FakeRoot
}
Create'AlignOrientation'{
    MaxTorque=math.huge,
    MaxAngularVelocity=math.huge,
    Responsiveness=200,
    Attachment0=A0,
    Attachment1=A1,
    Parent=FakeRoot
}
for _,x in next,{121572214,182393478}do
	local Anim=Create'Animation'{
		AnimationId=`rbxassetid://{x}`
	}
	local AnimationTrack=Character.Humanoid.Animator:LoadAnimation(Anim)
	AnimationTrack.Priority=Enum.AnimationPriority.Action4
	AnimationTrack:Play()
	AnimationTrack:AdjustSpeed(99)
	task.spawn(function()
		task.wait()
		AnimationTrack:AdjustSpeed(0)
	end)
end
