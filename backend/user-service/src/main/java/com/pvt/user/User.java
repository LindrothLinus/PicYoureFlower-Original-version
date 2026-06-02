package com.pvt.user;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import jakarta.persistence.CascadeType;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String googleId;
    private String email;
    private String name;
    private int coins;
    private int likes;
    private String profilePicture;

    public String getProfilePicture() {
        return profilePicture;
    }

    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }

    public int getLikes() {
        return this.likes;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }
    
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PotEntity> pots = new ArrayList<>();

    @ManyToMany
    @JoinTable(name = "user_friends", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "friend_id"))
    private Set<User> friends = new HashSet<>();

    @ElementCollection
    @CollectionTable(name = "user_owned_pots", joinColumns = @JoinColumn(name = "user_id"))
    @Enumerated(EnumType.STRING)
    @Column(name = "template")
    private Set<PotTemplate> ownedPotTemplates = new HashSet<>(Set.of(PotTemplate.BLUE));

    public Set<PotTemplate> getOwnedPotTemplates() {
        return ownedPotTemplates;
    }

    public void setOwnedPotTemplates(Set<PotTemplate> ownedPotTemplates) {
        this.ownedPotTemplates = ownedPotTemplates;
    }

    public Set<User> getFriends() {
        return this.friends;
    }

    public void setFriends(Set<User> friends) {
        this.friends = friends;
    }

    public List<PotEntity> getPots() {
        return this.pots;
    }

    public void setPots(List<PotEntity> pots) {
        this.pots = pots;
    }

    public int getCoins() {
        return this.coins;
    }

    public void setCoins(int coins) {
        this.coins = coins;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String g) {
        this.googleId = g;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String e) {
        this.email = e;
    }

    public String getName() {
        return name;
    }

    public void setName(String n) {
        this.name = n;
    }
}