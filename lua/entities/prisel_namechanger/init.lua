AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/breen.mdl")
	self:SetBodygroup(1,1)
	self:SetSolid(SOLID_BBOX)

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()

	self:SetNPCState(NPC_STATE_SCRIPT)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetMoveType(MOVETYPE_NONE)

	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
end

function ENT:OnTakeDamage()
	return false
end

local cooldownPlayers = {}

function ENT:Use( act, pCaller )
	if not IsValid( pCaller ) or not pCaller:IsPlayer() then
		return
	end

	if cooldownPlayers[pCaller] and cooldownPlayers[pCaller] > CurTime() then
		return
	end

	cooldownPlayers[pCaller] = CurTime() + 3

	net.Start("Prisel::RPName::Main")
		net.WriteUInt(1, 3)
		net.WriteBool(false)
	net.Send(pCaller)

end