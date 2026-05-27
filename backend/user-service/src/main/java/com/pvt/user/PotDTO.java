package com.pvt.user;

public record PotDTO(Long id, PotTemplate template, int placementId, Long flowerId, boolean placed) {}
