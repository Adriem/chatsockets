# ==============================================================================
#  This file contains the user model for the database
# ==============================================================================

mongoose = require 'mongoose'
bCrypt   = require 'bcrypt-nodejs'

userSchema = new mongoose.Schema
  username : {type: String, required: true, unique: true}
  password : {type: String, required: true}

# Hash passwords before saving them
userSchema.pre 'save', (callback) ->
  if this.isModified('password') then bcrypt.genSalt (err, salt) =>
    if err then callback(err); return
    bCrypt.hash this.password, salt, null, (err, hash) =>
      if err then callback(err); return
      this.password = hash
      callback()
  else callback()

# Verify password function
userSchema.methods.verifyPassword = (password, callback) ->
  bCrypt.compare(password, @password, callback)

module.exports = mongoose.model('User', userSchema)
